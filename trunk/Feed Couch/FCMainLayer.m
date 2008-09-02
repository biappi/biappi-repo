//
//  FCMainLayer.m
//  Feed Couch
//
//  Created by Antonio Malara on 01/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FCMainLayer.h"
#import "FCEntryBox.h"

#import <PubSub/PubSub.h>

static int entriesArraySortHelper(id a, id b, void * ctx)
{
	PSEntry * uno = (PSEntry *) a;
	PSEntry * due = (PSEntry *) b;
	
	return [uno.dateForDisplay compare:due.dateForDisplay];
}

@implementation FCMainLayer

- (id)init;
{
	if ([super initWithFile:[[NSBundle mainBundle] pathForResource:@"bg" ofType:@"qtz"]] == nil)
		return nil;
	
	PSClient * client = [PSClient clientForBundleIdentifier:@"com.apple.Safari"];
	NSMutableArray * entries = [NSMutableArray array];
		
	for (PSFeed * feed in client.feeds)
		for (PSEntry * entry in feed.entries)
			[entries addObject:entry];
	
	[entries sortUsingFunction:&entriesArraySortHelper context:nil];
	
	if ([entries count] > 5)
		[entries removeObjectsInRange:NSMakeRange(5, [entries count] - 5)];
	
	maxSize = CGSizeZero;
	
	for (PSEntry * entry in entries)
	{
		FCEntryBox * box = [[FCEntryBox alloc] initWithEntry:entry];
		[self addSublayer:box];
		
		CGSize size = [box preferredFrameSize];
		
		if (size.width > maxSize.width)
			maxSize.width = size.width;
		
		if (size.height > maxSize.height)
			maxSize.height = size.height;
	}
	
	state = kCollapsedState;
	info = nil;
	
	return self;
}

- (void)layoutSublayers;
{
	CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2 * 0.8; // 80% of the viewport
	CGFloat angle = 0;
		
	CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);	
	CGFloat angleStep = 2 * M_PI / [self.sublayers count];

	if (state == kReadingState)
	{
		FCBezeledBox * sel = [self.sublayers objectAtIndex:selectedEntry];
		sel.opacity = 1;		
		sel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
		[sel setState:kTopBarState];
		
		for (FCBezeledBox * box in self.sublayers)
		{
			if (box == sel)
				continue;
			
			[box setState:kUnselectedState];
			box.frame = CGRectMake((self.bounds.size.width + maxSize.width) / 2,
								   (self.bounds.size.height + maxSize.height) / 2,
								   maxSize.width,
								   maxSize.height);
			box.position = self.position;
			box.opacity = 0;
		}

		return;
	}
	
	if (state == kCollapsedState)
	{
		CGRect newBounds = CGRectZero;
		newBounds.size = maxSize;
		
		for (FCBezeledBox * box in self.sublayers)
		{
			box.position = self.position;
			//box.bounds = newBounds;
			box.opacity = 0;
		}
		
		return;
	}	
	
	int i;
	for (i = 0; i < [self.sublayers count]; i++)
	{
		FCBezeledBox * box = [self.sublayers objectAtIndex:((selectedEntry + i) % [self.sublayers count])];

		CGRect newBounds = CGRectZero;
		newBounds.size = maxSize;
		box.bounds = newBounds;		
		box.opacity = 1;
		box.position = CGPointMake(center.x + radius * cosf(angle), center.y + radius * sinf(angle));
		angle += angleStep;
		
		if (((selectedEntry + i) % [self.sublayers count]) == selectedEntry)
			[box setState:kSelectedState];
		else
			[box setState:kUnselectedState];
	}	
}

- (mainLayerState)state;
{
	return state;
}

- (void)setState:(mainLayerState)flag;
{
	state = flag;
	[self layoutSublayers];
}

- (void)changeSelect:(int)howMuch;
{
	CFIndex count = [self.sublayers count];
	if (count == 0)
		return;
	
	selectedEntry += howMuch;
	if (selectedEntry > count - 1)
		selectedEntry = 0;
	
	if (selectedEntry < 0)
		selectedEntry = count - 1;
	
	if (state == kCollapsedState)
		state = kWheelState;
	
	[self setNeedsLayout];
}

- (void)play;
{
	switch (state)
	{
		case kWheelState:
			[self setState:kReadingState];
			break;
		
		case kReadingState:
			NSLog(@"++");
			NSLog([[self.sublayers objectAtIndex:selectedEntry] description]);
			[[self.sublayers objectAtIndex:selectedEntry] openUrl];
			break;
	}		
}

- (void)goBack;
{
	switch (state)
	{
		case kCollapsedState:
			NSBeep();
			break;
		
		case kWheelState:
			[self setState:kCollapsedState];
			break;
		
		case kReadingState:
			[self setState:kWheelState];
			break;
	}
}

@end
