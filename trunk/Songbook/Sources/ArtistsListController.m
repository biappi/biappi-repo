//
//  ArtistsListController.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 21/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ArtistsListController.h"
#import "SongbookDB.h"
#import "AddSongController.h"
#import "SongsListController.h"

@implementation ArtistsListController

- (id)init;
{
	if ((self = [super initWithStyle:UITableViewStylePlain]) == nil)
		return nil;
	
	self.title = @"Artists";
	
	artists = [[[SongbookDB db] artists] retain];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dbDirty:) name:@"db updated" object:nil];
	
	self.tabBarItem.image = [UIImage imageNamed:@"a.png"];
	
	return self;
}

- (void)dealloc;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[artists release];
	[super dealloc];
}

- (void)dbDirty:(BOOL)f;
{
	[artists release];
	artists = [[[SongbookDB db] artists] retain];
	[self.tableView reloadData];
}

#pragma mark Actions

- (void)addSong;
{
}

#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [artists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
	cell.text = [artists objectAtIndex:indexPath.row];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	SongsListController * slc = [[SongsListController alloc] initWithArtist:[artists objectAtIndex:indexPath.row]];
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	[self.navigationController pushViewController:slc animated:YES];
	[slc release];
}

@end

