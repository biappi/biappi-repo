//
//  SongViewController.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 24/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SongViewController.h"
#import "SongbookDB.h"
#import "PRO2HTML.h"
#import "EditSongController.h"
#import "RotatingTabBarController.h"

@interface UIDevice()

- (void) setOrientation:(UIInterfaceOrientation)x;

@end

@interface SongViewController()

- (void)destroyTimer;
- (void)edit;
- (void)scroll;
- (void)stopScrolling;

@end

@implementation SongViewController

- (id)initWithSongID:(NSInteger)songid;
{
	if ((self = [self initWithNibName:nil bundle:nil]) == nil)
		return nil;
	
	songID = songid;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dbDirty:) name:@"db updated" object:nil];

	self.title = [song objectForKey:@"title"];
	toolsBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																   target:self
																   action:@selector(tools)];
	
	self.navigationItem.rightBarButtonItem = toolsBarButton;

	scrollingSpeed = 3;
	
	return self;
}

- (void)dealloc;
{
	[toolsBarButton release];
	[actionBarButton release];
	[stopScrollingButton release];
	[scrollingSpeedButton release];
	[scrollTimer release];
	[song release];
	[songView release];
	[super dealloc];
}

- (void)dbDirty:(id)x;
{
	[song release];
	song = [[[SongbookDB db] songWithID:songID] retain];
	[songView loadHTMLString:parsePROToHTML([song objectForKey:@"chords"]) baseURL:nil];
}

- (void)loadView;
{
	songView = [[UIWebView alloc] initWithFrame:CGRectZero];
	songView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	songView.delegate = self;
	
	self.view = songView;

	UISegmentedControl * speedControl;
	speedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"-", @"+", nil]];
	speedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	speedControl.momentary = YES;
	
	[speedControl addTarget:self
					 action:@selector(speedChanged:)
		   forControlEvents:UIControlEventValueChanged];
	
	
	scrollingSpeedButton = [[UIBarButtonItem alloc] initWithCustomView:speedControl];
	stopScrollingButton  = [[UIBarButtonItem alloc] initWithTitle:@"Stop"
															style:UIBarButtonItemStyleBordered
														   target:self
														   action:@selector(stopScrolling)];
	[speedControl release];
	[self dbDirty:nil];
}

- (BOOL)hidesBottomBarWhenPushed;
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated;
{
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	((RotatingTabBarController *)self.tabBarController).rotateEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated;
{
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	((RotatingTabBarController *)self.tabBarController).rotateEnabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated;
{
	[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];	
}

- (void)tools;
{
	UIActionSheet * tools;
	tools = [[UIActionSheet alloc] initWithTitle:nil
										delegate:self
							   cancelButtonTitle:@"Cancel" 
						  destructiveButtonTitle:nil
							   otherButtonTitles:@"Edit Song",
												 @"Start Autoscroller",
												 nil];
	[tools showInView:self.view];
	[tools release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
	switch (buttonIndex)
	{
		case 0:
			[self edit];
			break;

		case 1:
			[self scroll];
			break;
	}
}

- (void)edit;
{
	EditSongController * esc = [[EditSongController alloc] initWithSongID:[[song objectForKey:@"id"] intValue]];
	[self.navigationController pushViewController:esc animated:YES];
	[esc release];
}

- (void)scroll;
{	
	self.navigationItem.leftBarButtonItem  = scrollingSpeedButton;
	self.navigationItem.rightBarButtonItem = stopScrollingButton;
	
	self.navigationItem.title = [NSString stringWithFormat:@"Speed: %d", scrollingSpeed];
	
	[self destroyTimer];
	scrollTimer = [NSTimer scheduledTimerWithTimeInterval:(11 - scrollingSpeed) / 50.0
												   target:self
												 selector:@selector(scrollCB)
												 userInfo:nil
												  repeats:YES];
	[scrollTimer retain];
}

- (void)scrollCB;
{
	[songView stringByEvaluatingJavaScriptFromString:@"scrollBy(0, 1)"];
	NSString * end = [songView stringByEvaluatingJavaScriptFromString:@"(window.pageYOffset + window.innerHeight) == document.body.clientHeight"];
	
	if ([end isEqualToString:@"true"])
		[self stopScrolling];
}

- (void)stopScrolling;
{
	[self destroyTimer];
	
	self.navigationItem.leftBarButtonItem  = self.navigationItem.backBarButtonItem;
	self.navigationItem.rightBarButtonItem = toolsBarButton;
	self.navigationItem.title = nil;
}

- (void)destroyTimer;
{
	[scrollTimer invalidate];
	[scrollTimer release];
	scrollTimer = nil;	
}

- (void)speedChanged:(id)sender;
{
	NSInteger selected = [sender selectedSegmentIndex];
	
	switch (selected) 
	{
		case 0:
			scrollingSpeed--;
			break;
		
		case 1:
			scrollingSpeed++;
			break;
	}
	
	[sender setEnabled:(scrollingSpeed >  1) forSegmentAtIndex:0];
	[sender setEnabled:(scrollingSpeed < 10) forSegmentAtIndex:1];
	
	[self scroll];
}

@end
