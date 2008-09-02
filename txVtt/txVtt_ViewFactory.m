//
//  txVtt_ViewFactory.m
//  txVtt
//
//  Created by Antonio Malara on 08/01/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "txVtt_ViewFactory.h"

@implementation txVtt_ViewFactory

// string description of the Cocoa UI
- (NSString *) description {
	return @"txVtt AU";
}

// N.B.: this class is simply a view-factory,
// returning a new autoreleased view each time it's called.
- (NSView *)uiViewForAudioUnit:(AudioUnit)inAU withSize:(NSSize)inPreferredSize {
	if ([NSBundle loadNibNamed: @"txVtt_View" owner:self] == NO)
	{
        NSLog (@"Unable to load nib for view.");
		return nil;
	}
    
    [uiFreshlyLoadedView setAU:inAU];
    
    NSView *returnView = uiFreshlyLoadedView;
    uiFreshlyLoadedView = nil;
    
    return [returnView autorelease];
}

- (unsigned) interfaceVersion {
	return 0;
}

@end
