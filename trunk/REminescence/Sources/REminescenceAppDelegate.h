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

@interface REminescenceAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow * window;
	SystemStub * stub;
}

@property (nonatomic, retain) UIWindow * window;

@end
