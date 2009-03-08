//
//  SongbookAppDelegate.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 21/12/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "SongbookAppDelegate.h"
#import "PRODownloader.h"
#import "AddSongController.h"

@implementation SongbookAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application;
{	
	
	NSArray  * paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * docs   = [paths objectAtIndex:0];
	
	docs = [docs stringByAppendingPathComponent:@"songbook.db"];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:antonio.malara@gmail.com?attachment=\"%@\"", docs]]];
	
	mainController = [[MainTabController alloc] init];

	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window addSubview:mainController.view];
    [window makeKeyAndVisible];
}

- (void)dealloc;
{
	[mainController release];
    [window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
{
	NSString * urlString = [[url absoluteString] stringByReplacingCharactersInRange:NSMakeRange(0, 8) withString:@"http"];
	
	[mainController presentAddSongWithURL:urlString];
	return YES;
}

@end
