//
//  EditSongController.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 22/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "EditSongController.h"
#import "SongbookDB.h"
#import "PRO2HTML.h"

@implementation EditSongController

- (id)init;
{
	return [self initWithSongID:-1];
}

- (id)initWithSongID:(NSInteger)theSong;
{
	if ((self = [super initWithNibName:@"EditSong" bundle:nil]) == nil)
		return nil;
	
	songID = theSong;
	
	self.title = @"Edit Song";
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																							target:self
																							action:@selector(done)];
	
	self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						   target:self
																						   action:@selector(cancel)];
	[self.navigationItem.rightBarButtonItem release];
	[self.navigationItem.leftBarButtonItem  release];

	return self;
}

- (void)viewDidLoad;
{
	[songText addSubview:artistCell];
	[songText addSubview:titleCell];
	
	artistCell.frame = CGRectMake(0, -89, 320, 44);
	titleCell.frame  = CGRectMake(0, -45, 320, 44);
	
	if (songID != -1)
	{
		NSDictionary * song = [[SongbookDB db] songWithID:songID];
		
		NSMutableString * songChords = [NSMutableString stringWithString:[song objectForKey:@"chords"]];
		
		zapTitleAndSubtitle(songChords);
		
		artistField.text = [song objectForKey:@"artist"];
		titleField.text  = [song objectForKey:@"title"];
		songText.text    = [songChords stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		songText.selectedRange = NSMakeRange(0, 0);
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
		
	[songText becomeFirstResponder];	
}

#pragma mark Actions

- (void)done;
{
	NSString * chords = [NSString stringWithFormat:@"{title: %@}\n{subtitle: %@}\n%@",
													titleField.text,
													artistField.text,
													songText.text];
	if (songID == -1)
		[[SongbookDB db] insertSongWithArtist:artistField.text title:titleField.text chords:chords];
	else
		[[SongbookDB db] updateSongID:songID withArtist:artistField.text title:titleField.text chords:chords];
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel;
{
	UIActionSheet * ac = [[UIActionSheet alloc] initWithTitle:@"Really cancel?"
													 delegate:self
											cancelButtonTitle:@"Continue Editing"
									   destructiveButtonTitle:@"Cancel Anyway"
											otherButtonTitles:nil];
	[ac showInView:self.view.window];
	[ac release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
	if (buttonIndex == 0)
		[self.navigationController popViewControllerAnimated:YES];

	return;
}

#pragma mark UIKeyboard Notifications

- (void)viewWillDisappear:(BOOL)animated;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardDidShow:(NSNotification *)noti;
{
	CGRect keyBounds = [[[noti userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
	CGRect viewFrame = songText.frame;
	
	viewFrame.size.height -= keyBounds.size.height - 49;
	
	songText.frame = viewFrame;
}

- (void)keyboardWillHide:(NSNotification *)noti;
{
	CGRect keyBounds = [[[noti userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
	CGRect viewFrame = songText.frame;
	
	viewFrame.size.height += keyBounds.size.height - 49;
	
	songText.frame = viewFrame;
}

@end
