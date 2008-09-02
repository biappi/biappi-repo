//
//  txVtt_MainView.m
//  txVtt
//
//  Created by Antonio Malara on 08/01/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "txVtt_MainView.h"
#import "txVtt_Parameters.h"
#import "txVtt_InnerView.h"

void EventListenerDispatcher (void *inRefCon, void *inObject, const AudioUnitEvent *inEvent, UInt64 inHostTime, Float32 inValue)
{
	txVtt_MainView *SELF = (txVtt_MainView *)inRefCon;
	[SELF priv_eventListener:inObject event: inEvent value: inValue];
}

@implementation txVtt_MainView

- (void) dealloc;
{
	if (eventListener)
		AUListenerDispose(eventListener);
	
	[super dealloc];
}


- (void)setAU:(AudioUnit)newAU;
{
	if (newAU == nil)
		return;

	au = newAU;
	
	AUEventListenerCreate(EventListenerDispatcher, self, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 0.05, 0.05, &eventListener);

	AudioUnitEvent auEvent;
	
	auEvent.mEventType = kAudioUnitEvent_ParameterValueChange;
	auEvent.mArgument.mParameter.mAudioUnit = au;
	auEvent.mArgument.mParameter.mParameterID = kDoScratch;
	auEvent.mArgument.mParameter.mScope = kAudioUnitScope_Global;
	auEvent.mArgument.mParameter.mElement = 0;
	
	AUEventListenerAddEventType(eventListener, self, &auEvent);

	auEvent.mEventType = kAudioUnitEvent_PropertyChange;
	auEvent.mArgument.mProperty.mAudioUnit = au;
	auEvent.mArgument.mProperty.mPropertyID = kFilenameProperty;
	auEvent.mArgument.mProperty.mScope = kAudioUnitScope_Global;
	auEvent.mArgument.mProperty.mElement = 0;
	
	AUEventListenerAddEventType(eventListener, self, &auEvent);
	
	[(txVtt_InnerView *)inner setAU:au];
	
	UInt32 size;
	CFStringRef filename;
				
	AudioUnitGetProperty(au, kFilenameProperty, kAudioUnitScope_Global, 0, &filename, &size);
	if (filename != nil)
		[(NSTextField *)label setStringValue:(NSString *)filename];
	else
		[(NSTextField *)label setStringValue:@" - No Sample -"];
}

- (void)faiQualcosa:(id)sender
{	
	NSOpenPanel * panel = [NSOpenPanel openPanel];
	[panel runModalForTypes: nil];
	
	if (AudioUnitSetProperty(au, kFilenameProperty, kAudioUnitScope_Global, 0, (void *)[[panel URL] path], sizeof (NSString *)) != noErr)
		NSBeep();
}

- (void)trigger:(id)sender
{
	AudioUnitSetParameter(au, kTrigger, kAudioUnitScope_Global, 0, 1, 0);
}

- (void)priv_eventListener:(void *)inObject event:(const AudioUnitEvent *)inEvent value:(Float32)inValue
{
	switch (inEvent->mEventType)
	{
		case kAudioUnitEvent_ParameterValueChange:
			if (inEvent->mArgument.mParameter.mParameterID == kDoScratch)
				[inner setDoScratch:inValue];
				break;

		case kAudioUnitEvent_PropertyChange:
			if (inEvent->mArgument.mProperty.mPropertyID == kFilenameProperty)
			{
				UInt32 size;
				CFStringRef filename;
				
				AudioUnitGetProperty(au, kFilenameProperty, kAudioUnitScope_Global, 0, &filename, &size);
				[(NSTextField *)label setStringValue:(NSString *)filename];
			}
			break;
	}
}

- (AUEventListenerRef)eventListener;
{
	return eventListener;
}

@end
