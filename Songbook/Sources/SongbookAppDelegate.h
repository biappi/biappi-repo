//
//  SongbookAppDelegate.h
//  Songbook
//
//  Created by Antonio "Willy" Malara on 21/12/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabController.h"

@interface SongbookAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow          * window;
	MainTabController * mainController;
}

@property (nonatomic, retain) UIWindow * window;

@end

