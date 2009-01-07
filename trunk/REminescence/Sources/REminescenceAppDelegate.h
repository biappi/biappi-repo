//
//  REminescenceAppDelegate.h
//  REminescence
//
//  Created by Antonio "Willy" Malara on 06/01/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "game.h"
#import "systemstub.h"

@class REminescenceDPadView, REminescenceButtonView, REminescenceGameView;

@interface REminescenceAppDelegate : NSObject <UIApplicationDelegate>
{
	SystemStub * stub;

	IBOutlet UIWindow * window;
	
	IBOutlet REminescenceDPadView* dpad;
	IBOutlet REminescenceButtonView* spaceButton;
	IBOutlet REminescenceButtonView* escapeButton;
	IBOutlet REminescenceButtonView* enterButton;
	IBOutlet REminescenceButtonView* shiftButton;
	IBOutlet REminescenceButtonView* backspaceButton;
	
	IBOutlet REminescenceGameView* gameView;
}

@property(nonatomic, retain) UIWindow   * window;
@property(readonly)          SystemStub * systemStub;
@property(nonatomic, retain) REminescenceGameView* gameView;

- (void) setEnterPressed:(BOOL) enter;
- (void) setEscapePressed:(BOOL) escape;
- (void) setSpacePressed:(BOOL) space;
- (void) setShiftPressed:(BOOL) shift;
- (void) setBackspacePressed:(BOOL) backspace;

@end
