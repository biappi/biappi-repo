//
//  REminescenceDPad.m
//  REminescence
//
//  Created by ∞ on 07/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "REminescenceDPadView.h"
#import "REminescenceAppDelegate.h"
#import "systemstub.h"

@interface REminescenceDPadView ()
- (void) _updateDelegateWithTouchLocation:(CGPoint) p;
- (void) _updateDelegateWithNoTouches;
@end

@implementation REminescenceDPadView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.userInteractionEnabled = YES;
		self.multipleTouchEnabled = NO;
    }
    return self;
}


- (void)awakeFromNib {
	[super awakeFromNib];
	self.userInteractionEnabled = YES;
	self.multipleTouchEnabled = NO;
}

- (void) _updateDelegateWithTouchLocation:(CGPoint) p {
	CGRect bounds = self.bounds;
	BOOL up, down, left, right;
	
	up = (p.y < (bounds.size.height / 3.0));
	down = (p.y > (bounds.size.height * (2.0 / 3.0)));
	left = (p.x < (bounds.size.width / 3.0));
	right = (p.x > (bounds.size.height * (2.0 / 3.0)));

	L0Log(@"Up = %d, down = %d, left = %d, right = %d", up, down, left, right);
	
	REminescenceAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
	SystemStub* stub = delegate.systemStub;

	stub->_pi.dirMask = 0;
	if (up) stub->_pi.dirMask |= PlayerInput::DIR_UP;
	if (down) stub->_pi.dirMask |= PlayerInput::DIR_DOWN;
	if (left) stub->_pi.dirMask |= PlayerInput::DIR_LEFT;
	if (right) stub->_pi.dirMask |= PlayerInput::DIR_RIGHT;
}

- (void) _updateDelegateWithNoTouches {
	L0Log(@"Cleared.");
	
	REminescenceAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
	SystemStub* stub = delegate.systemStub;
	stub->_pi.dirMask = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* t = [touches anyObject];
	[self _updateDelegateWithTouchLocation:[t locationInView:self]];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* t = [touches anyObject];
	[self _updateDelegateWithTouchLocation:[t locationInView:self]];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self _updateDelegateWithNoTouches];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self _updateDelegateWithNoTouches];
}

- (void)dealloc {
    [super dealloc];
}


@end
