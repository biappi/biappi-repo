//
//  REminescenceAppDelegate.m
//  REminescence
//
//  Created by Antonio "Willy" Malara on 06/01/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "REminescenceAppDelegate.h"

@implementation REminescenceAppDelegate

@synthesize window;

- (void)startItAll:(id)unused;
{
	
	const char * dataPath = [[[NSBundle mainBundle] pathForResource:@"data" ofType:nil] UTF8String];
	
	Game *g = new Game(stub, dataPath, "-", VER_EN);
	g->run();
	delete g;
}

- (void)puppa:(id)p;
{
	NSLog(@"sdf");
}

- (void)applicationDidFinishLaunching:(UIApplication *)application;
{
	stub = SystemStub_SDL_create();
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window makeKeyAndVisible];
		
	[self performSelector:@selector(startItAll:) withObject:nil afterDelay:0];
	[self performSelector:@selector(puppa:) withObject:nil afterDelay:5];
}

- (void)dealloc;
{
	delete stub;
    [window release];
    [super dealloc];
}


@end
