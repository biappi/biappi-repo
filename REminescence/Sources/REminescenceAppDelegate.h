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

@class REminescenceDPadView, REminescenceButtonView;

@interface REminescenceAppDelegate : NSObject <UIApplicationDelegate>
{
    IBOutlet UIWindow* window;
	SystemStub* stub;
	
	IBOutlet REminescenceDPadView* dpad;
	IBOutlet REminescenceButtonView* spaceButton;
	IBOutlet REminescenceButtonView* escapeButton;	
}

@property (nonatomic, retain) UIWindow * window;

@property(readonly) SystemStub* systemStub;

- (void) setEnterPressed:(BOOL) enter;
- (void) setEscapePressed:(BOOL) enter;
- (void) setSpacePressed:(BOOL) enter;

@end
