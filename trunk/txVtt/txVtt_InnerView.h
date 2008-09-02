//
//  txVtt_InnerView.h
//  txVtt
//
//  Created by Antonio Malara on 10/01/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AudioUnit/AudioUnit.h>

@interface txVtt_InnerView : NSView
{
	NSColor * background;
	AudioUnit au;
	bool scratching;
}

- (void)setAU:(AudioUnit)newAU;
- (void)setDoScratch:(bool)newDo;

@end
