//
//  FCMainLayer.h
//  Feed Couch
//
//  Created by Antonio Malara on 01/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

typedef enum {
	kCollapsedState,
	kWheelState,
	kReadingState
} mainLayerState;

@interface FCMainLayer : QCCompositionLayer {
	NSMutableArray * entriesLayers;
	CFIndex selectedEntry;

	CGSize maxSize;

	mainLayerState state;
	CATextLayer * info;
}

@property(readwrite) mainLayerState state;

- (void)changeSelect:(int)howMuch;
- (void)play;
- (void)goBack;

@end
