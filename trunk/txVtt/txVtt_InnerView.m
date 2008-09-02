//
//  txVtt_InnerView.m
//  txVtt
//
//  Created by Antonio Malara on 10/01/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "txVtt_InnerView.h"
#import "txVtt_MainView.h"
#import "txVtt_Parameters.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation txVtt_InnerView

- (void)setAU:(AudioUnit)newAU;
{
	au = newAU;
}

- (void)awakeFromNib;
{
	background = [NSColor blackColor];
}

- (void)drawRect:(NSRect)rect;
{
	[background set];
	NSRectFill(rect);
}

- (void)mouseMoved:(NSEvent *)ev;
{
	AudioUnitSetParameter(au, kPixelScratch, kAudioUnitScope_Global, 0, [ev deltaX], 0);
}

- (void)mouseDown:(NSEvent *)event;
{
	AudioUnitParameter param;
	float temp;
	
	AudioUnitGetParameter(au, kDoScratch, kAudioUnitScope_Global, 0, &temp);
	
	param.mAudioUnit = au;
	param.mParameterID = kDoScratch;
	param.mScope = kAudioUnitScope_Global;
	param.mElement = 0;

	AUParameterSet([(txVtt_MainView *)[self superview] eventListener], self, &param, !temp, 0);
}

- (void)setDoScratch:(bool)newDo;
{
	if (newDo == YES)
	{
		background = [NSColor blueColor];
		[[self window] makeFirstResponder: self];
		[[self window] setAcceptsMouseMovedEvents: YES];
	} else {
		background = [NSColor blackColor];
		[[self window] setAcceptsMouseMovedEvents: NO];
	}
	
	[self setNeedsDisplay: YES];
}

@end
