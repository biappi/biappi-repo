//
//  SongsListController.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 22/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SongsListController.h"
#import "SongbookDB.h"
#import "AddSongController.h"
#import "SongViewController.h"

@implementation SongsListController

- (id)init;
{
	return [self initWithArtist:nil];
}

- (id)initWithArtist:(NSString *)a;
{
	if ((self = [super initWithStyle:UITableViewStylePlain]) == nil)
		return nil;

	if (a == nil)
		self.title = @"Songs";
	else
		self.title = a ;
	
	self.tabBarItem.image = [UIImage imageNamed:@"n.png"];
	
	artist = [a retain];

	if (artist == nil)
		songs = [[[SongbookDB db] allSongs] retain];
	else
		songs = [[[SongbookDB db] songsForArtist:artist] retain];
		
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dbDirty:) name:@"db updated" object:nil];
	
	return self;
}

- (void)dealloc;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[artist release];
	[songs release];
	[super dealloc];
}

- (void)dbDirty:(BOOL)f;
{
	[songs release];
		
	if (artist == nil)
		songs = [[[SongbookDB db] allSongs] retain];
	else
		songs = [[[SongbookDB db] songsForArtist:artist] retain];
	
	// This solves the > 2.2 crash for tableview invariant
	if (self.editing == NO)
		[self.tableView reloadData];
}

#pragma mark Actions

- (void)addSong;
{
}

#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	if (section == 0)
		return [songs count];

	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString * cellID = @"Cell";
    	
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
	cell.text = [[songs objectAtIndex:indexPath.row] objectForKey:@"title"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	UIViewController * svc = [[SongViewController alloc] initWithSongID:[[[songs objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]];
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
	[self.navigationController pushViewController:svc animated:YES];
	[svc release];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		[[SongbookDB db] deleteSongWithID:[[[songs objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]];

		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

@end

