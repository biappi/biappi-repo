//
//  REminescenceAppDelegate.m
//  REminescence
//
//  Created by Antonio "Willy" Malara on 06/01/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "REminescenceAppDelegate.h"
#import "REminescenceDPadView.h"
#import "REminescenceButtonView.h"

@implementation REminescenceAppDelegate

@synthesize window, gameView;

- (void)applicationWillResignActive:(UIApplication *)application;
{
	self.systemStub->_pi.escape = true;
	// TODO a better way to pause (hi battery!)
}

- (void)startItAll:(id)unused;
{
	
	const char * dataPath = [[[NSBundle mainBundle] pathForResource:@"data" ofType:nil] fileSystemRepresentation];
	
	NSArray* docsDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSAssert([docsDirs count] > 0, @"At least one Documents directory exists");
	NSString* docsDir = [docsDirs objectAtIndex:0];
	
	while (true) {
		Game *g = new Game(stub, dataPath, [docsDir fileSystemRepresentation], VER_EN);
		g->run();
		delete g;
	}
}

- (void)applicationDidFinishLaunching:(UIApplication *)application;
{
	stub = SystemStub_iPhoneOS_create();

	spaceButton.delegateKey  = @"spacePressed";
	escapeButton.delegateKey = @"escapePressed";
	enterButton.delegateKey = @"enterPressed";
	shiftButton.delegateKey = @"shiftPressed";
	backspaceButton.delegateKey = @"backspacePressed";
	
	[UIApplication sharedApplication].statusBarHidden = YES;
	window.frame = [UIScreen mainScreen].bounds;
	[window makeKeyAndVisible];
		
	[self performSelector:@selector(startItAll:) withObject:nil afterDelay:0];
}

- (void)dealloc;
{
	delete stub;
    [window release];
	[gameView release];
    [super dealloc];
}

- (SystemStub*) systemStub;
{
	return stub;
}

- (void)setEnterPressed:(BOOL)enter;
{
	stub->_pi.enter = enter;
}

- (void)setEscapePressed:(BOOL)escape;
{
	stub->_pi.escape = escape;
}

- (void)setSpacePressed:(BOOL)space;
{
	stub->_pi.space = space;
}

- (void) setShiftPressed:(BOOL) shift {
	stub->_pi.shift = shift;
}

- (void) setBackspacePressed:(BOOL) backspace {
	stub->_pi.backspace = backspace;
}

@end
