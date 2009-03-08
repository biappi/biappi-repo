//
//  MainTabController.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 21/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MainTabController.h"
#import "ArtistsListController.h"
#import "SongsListController.h"
#import "AddSongController.h"
#import "InfoViewController.h"

@implementation MainTabController

- (id)init;
{
	if ((self = [super init]) == nil)
		return nil;

	
	ArtistsListController  * artistsController = [[ArtistsListController alloc] init];
	UINavigationController * artistsNavigation = [[UINavigationController alloc] initWithRootViewController:artistsController];
	[artistsController release];
	
	SongsListController    * songsController   = [[SongsListController alloc] init];
	UINavigationController * songsNavigation   = [[UINavigationController alloc] initWithRootViewController:songsController];
	[songsController release];	
	
	AddSongController      * addSongController = [[AddSongController alloc] init];
	UINavigationController * addSongNavigation = [[UINavigationController alloc] initWithRootViewController:addSongController];
	[addSongController release];
	
	InfoViewController     * infoController    = [[InfoViewController alloc] init];
	
	self.viewControllers = [NSArray arrayWithObjects:artistsNavigation,
													 songsNavigation,
													 addSongNavigation,
													 infoController,
													 nil];
	[artistsNavigation release];
	[songsNavigation release];
	[addSongNavigation release];
	[infoController release];
	
	return self;
}

- (void)presentAddSongWithURL:(NSString *)url;
{
	self.selectedIndex = 2;
	[(AddSongController *)[[self.viewControllers objectAtIndex:2] topViewController] setURL:url];
}

@end
