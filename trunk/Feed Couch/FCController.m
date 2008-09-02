//
//  FCController.m
//  Feed Couch
//
//  Created by Antonio Malara on 01/07/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "FCController.h"
#import "FCMainLayer.h"

#import "RemoteControlContainer.h"
#import "AppleRemote.h"

NSView * theView;

@implementation FCController

- (void)awakeFromNib;
{
	FCMainLayer * l = [[FCMainLayer alloc] init];
	l.backgroundColor = CGColorGetConstantColor(kCGColorBlack);
	[view setLayer:l];
	[view setWantsLayer:YES];
	
	[[view window] makeFirstResponder:self];
	[self performSelector:@selector(collapseOut) withObject:nil afterDelay:0.5];

	RemoteControlContainer * remoteContainer = [[RemoteControlContainer alloc] initWithDelegate: self];
	[remoteContainer instantiateAndAddRemoteControlDeviceWithClass: [AppleRemote class]];	
	
	[remoteContainer startListening: self];
	
	theView = view;
}

- (void)collapseOut;
{
	FCMainLayer * l = (FCMainLayer *)[view layer];
	l.state = kWheelState;
}

#pragma mark Remote

- (void)sendRemoteButtonEvent:(RemoteControlEventIdentifier)event pressedDown:(BOOL)pressedDown remoteControl:(RemoteControl*) remoteControl
{
	if (pressedDown == NO)
		return;
	
	switch (event)
	{
		case kRemoteButtonMenu:
			[self goBack:nil];
			break;
		
		case kRemoteButtonLeft:
			[self moveLeft:nil];
			break;
		case kRemoteButtonRight:
			[self moveRight:nil];
			break;

		case kRemoteButtonPlay:
			[self insertNewline:nil];
			break;
	} 
}


#pragma mark Input

- (BOOL)acceptsFirstResponder;
{
	return YES;
}

- (void)keyDown:(NSEvent *)anEvent;
{
	if ([[anEvent charactersIgnoringModifiers] isEqualToString:@" "])
	{
		if ([view isInFullScreenMode])
			[view exitFullScreenModeWithOptions:[NSDictionary dictionary]];
		else {
			[view enterFullScreenMode:[NSScreen mainScreen] withOptions:[NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInteger:(NSInteger)1.0], @"NSFullScreenModeWindowLevel", nil]];
		}
		
		[[view window] makeFirstResponder:self];
	}
	
	[self interpretKeyEvents:[NSArray arrayWithObject:anEvent]];
}

- (void)goBack:(id)sender;
{
	FCMainLayer * l = (FCMainLayer *)[view layer];
	[l goBack];
}

- (void)moveLeft:(id)sender;
{
	FCMainLayer * l = (FCMainLayer *)[view layer];
	[l changeSelect:-1];
}

- (void)moveRight:(id)sender;
{
	FCMainLayer * l = (FCMainLayer *)[view layer];
	[l changeSelect:1];
}

- (void)insertNewline:(id)sender;
{
	FCMainLayer * l = (FCMainLayer *)[view layer];
	[l play];
}

@end
