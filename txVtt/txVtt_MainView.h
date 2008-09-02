//
//  txVtt_MainView.h
//  txVtt
//
//  Created by Antonio Malara on 08/01/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface txVtt_MainView : NSView
{
	AudioUnit au;
	AUEventListenerRef eventListener;
	
	IBOutlet id inner;
	IBOutlet id label;
}

- (void)setAU:(AudioUnit)newAU;
- (void)faiQualcosa:(id)sender;
- (void)trigger:(id)sender;
- (AUEventListenerRef)eventListener;

- (void)priv_eventListener:(void *)inObject event:(const AudioUnitEvent *)inEvent value:(Float32)inValue;

@end
