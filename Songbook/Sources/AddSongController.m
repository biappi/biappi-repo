//
//  AddSongController.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 22/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AddSongController.h"
#import "EditSongController.h"
#import "SongbookDB.h"
#import "PRODownloader.h"

@interface AddSongController (PrivateMethods)

- (void)tryToDownload;

@end

@implementation AddSongController

- (id)init;
{
	if ((self = [super init]) == nil)
		return nil;
	
	self.title = @"Add Song";
	
	urlField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 290, 24)];
	urlField.placeholder                   = @"Enter url here";
	urlField.delegate                      = self;
	urlField.enablesReturnKeyAutomatically = YES;
	urlField.autocapitalizationType        = UITextAutocapitalizationTypeNone;
	urlField.clearButtonMode               = UITextFieldViewModeAlways;
	urlField.keyboardType                  = UIKeyboardTypeURL;
	
	self.tabBarItem.image = [UIImage imageNamed:@"p.png"];
	
	return self;
}

- (void)dealloc;
{
	[urlField release];
	[super dealloc];
}

- (void)setURL:(NSString *)url;
{
	urlField.text   = url;
	[(UITableView *)self.view reloadData];
}

#pragma mark TableView Creation

- (void)loadView;
{
	UITableView * tv    = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	tv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	tv.delegate         = self;
	tv.dataSource       = self;
	self.view           = tv;
}

#pragma mark UIKeyboard Notifications

- (void)viewDidAppear:(BOOL)animated;
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];	
}

- (void)viewWillDisappear:(BOOL)animated;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardDidShow:(NSNotification *)noti;
{
	CGRect keyBounds = [[[noti userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
	CGRect viewFrame = self.view.frame;
	
	viewFrame.size.height -= keyBounds.size.height - 49;
	
	self.view.frame = viewFrame;
}

- (void)keyboardWillHide:(NSNotification *)noti;
{
	CGRect keyBounds = [[[noti userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
	CGRect viewFrame = self.view.frame;
	
	viewFrame.size.height += keyBounds.size.height - 49;
	
	self.view.frame = viewFrame;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	switch (section) {
		case 0:
			return 1;
		case 1:
			return 3;
	}
    return 0;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
	switch (section)
	{
		case 0:
			return @"This is the preferred way to do it, albeit a bit slow.";
		case 1:			
			return @"This is a commodity feature, it doesn't work well in "
					"all situations, considered the malformed-ness of the "
					"totality of .pro files in Internet.";
	}
	
	return nil;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{    
	static NSString * cellID    = @"cell";
	static NSString * fieldID   = @"field";
	UITableViewCell * cell      = [tableView dequeueReusableCellWithIdentifier:cellID];
	NSString        * identfier;
	
	if ((indexPath.section == 1) && (indexPath.row == 1))
		identfier = fieldID;
	else
		identfier = cellID;	
	
	if (cell == nil)
	{		
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identfier] autorelease];
		
		if (identfier == cellID)
			cell.textAlignment = UITextAlignmentCenter;
		else
			[cell.contentView addSubview:urlField];
	}
	
	if (identfier == cellID)
	{
		switch (indexPath.section)
		{
			case 0:
				cell.text          = @"By typing it on the iPhone";
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				break;
			
			case 1:
				switch (indexPath.row)
				{
					case 0:
						cell.accessoryType = UITableViewCellAccessoryNone;
						cell.text          = @"By trying to download a .pro file";
						break;
						
					case 2:
						cell.accessoryType = UITableViewCellAccessoryNone;
						cell.text          = @"Go for it!";
						break;
				}
				break;
		}
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	switch (indexPath.section)
	{
		case 0:
			if (urlField.editing == NO);
			{
				EditSongController * esc;
				esc = [[EditSongController alloc] init];
				[self.navigationController pushViewController:esc animated:YES];
				[esc release];
			}
			break;
		
		case 1:
			if (indexPath.row == 2)
			{
				[self tryToDownload];
			}
			
			break;
	}
	
	if (urlField.editing == YES)
		[urlField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
	[textField resignFirstResponder];
	return YES;
}

- (void)tryToDownload;
{
	if (urlField.text == nil)
		return;
	
	if ([urlField.text isEqual:@""])
		return;
	
	NSDictionary * result = parseFileAtUrl(urlField.text);
	NSString     * error  = [result objectForKey:@"error"];
	
	if (error != nil)
	{
		UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Error downloaing the file"
													  message:error
													 delegate:nil
											cancelButtonTitle:@"Dismiss"
											otherButtonTitles:nil];
		[av show];
		[av release];
		
		return;
	}
	
	NSString * artist = [result objectForKey:@"artist"];
	NSString * title  = [result objectForKey:@"title"];
	
	artist = (artist == nil) ? @"Unknown Artist" : artist;
	title  = (title  == nil) ? @"Unknown Title"  : title;
	
	[[SongbookDB db] insertSongWithArtist:artist title:title chords:[result objectForKey:@"chords"]];
	
	UIAlertView * av1 = [[UIAlertView alloc] initWithTitle:@"Done"
												  message:nil
												 delegate:nil
										cancelButtonTitle:@"Dismiss"
										otherButtonTitles:nil];
	[av1 show];
	[av1 release];
	
	return;	
}

@end
