//
//  UilliMappeAppDelegate.m
//  UilliMappe
//
//  Created by Antonio "Willy" Malara on 08/03/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "UilliMappeAppDelegate.h"

@implementation UilliMappeAppDelegate

@synthesize window;
@synthesize mapViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
{
	[window addSubview:mapViewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}

- (void)dealloc;
{
    [window release];
	[mapViewController release];
    [super dealloc];
}

@end
