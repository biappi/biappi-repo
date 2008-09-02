//
//  FCEntryBox.m
//  Feed Couch
//
//  Created by Antonio Malara on 01/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FCEntryBox.h"
#import "PSEntryAdditions.h"

extern NSView * theView;

@implementation FCEntryBox

@synthesize entry;

- (id)initWithEntry:(PSEntry *)anEntry;
{
	if ([super init] == nil)
		return nil;
	
	self.entry = anEntry;
	
	box = [[FCBezeledBox alloc] initWithAttributedString:[anEntry titleAttributedString]];
	box.anchorPoint = CGPointZero;
	[self addSublayer:box];
	
	scroll = 0;
	text = nil;
	inBrowser = NO;
	
	return self;
}

- (void)layoutSublayers;
{
	if (text != nil)
	{
		CGFloat margin = 60;
		CGSize pref = [box preferredFrameSize];
	
		box.frame = CGRectMake(-box.borderWidth,
							   self.bounds.size.height - pref.height + box.borderWidth,
							   self.bounds.size.width + 2 * box.borderWidth,
							   pref.height);
		
		info.frame = CGRectMake(0, 0, self.bounds.size.width, [info preferredFrameSize].height + 5);
		
		text.frame = CGRectMake(margin,
								margin + info.frame.size.height,
								self.bounds.size.width - margin * 2,
								self.bounds.size.height - box.frame.size.height - margin * 2 - info.frame.size.height);
	} else {
		box.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
	}
}

- (CGSize)preferredFrameSize;
{
	return [box preferredFrameSize];
}

- (void)setState:(int)state;
{
	[box setState:state];
	
	switch (state)
	{
		case kUnselectedState:
			self.affineTransform = CGAffineTransformIdentity;
			if (text != nil)
			{
				[box setString:[entry titleAttributedString]];
				[text removeFromSuperlayer];
				text = nil;
				[info removeFromSuperlayer];
				info = nil;
			}
			break;
			
		case kSelectedState:
			self.affineTransform = CGAffineTransformMakeScale(1.2, 1.2);
			if (text != nil)
			{
				[box setString:[entry titleAttributedString]];
				[text removeFromSuperlayer];
				text = nil;
				[info removeFromSuperlayer];
				info = nil;
			}
			break;
			
		case kTopBarState:
			if (text != nil)
				break;
			
			self.affineTransform = CGAffineTransformIdentity;
			
			[box setString:[entry titleAttributedStringWithSizes:30 e:40]];
			
			text = [CATextLayer layer];
			text.string = entry.content.plainTextString;
			text.wrapped = YES;
			text.truncationMode = kCATruncationEnd;
			text.masksToBounds = NO;
			[self addSublayer:text];
			
			info = [CATextLayer layer];
			info.string = @"Press Play To Read In Browser";
			info.font = @"Futura";
			info.fontSize = 18;
			info.backgroundColor = CGColorGetConstantColor(kCGColorWhite);
			info.foregroundColor = CGColorGetConstantColor(kCGColorBlack);
			info.alignmentMode = kCAAlignmentCenter;
			[self addSublayer:info];
			
			break;
	}
}

- (void)openUrl;
{
	if (inBrowser == YES)
	{
		[theView enterFullScreenMode:[NSScreen mainScreen] withOptions:[NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInteger:(NSInteger)1.0], @"NSFullScreenModeWindowLevel", nil]];
		inBrowser = NO;
	} else {
		[[NSWorkspace sharedWorkspace] openURL:entry.alternateURL];
		if ([theView isInFullScreenMode])
			[theView exitFullScreenModeWithOptions:[NSDictionary dictionary]];
	
		[[NSApplication sharedApplication] miniaturizeAll:nil];
		
		inBrowser = YES;
	}
}

@end
