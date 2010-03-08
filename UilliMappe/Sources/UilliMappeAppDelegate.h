//
//  UilliMappeAppDelegate.h
//  UilliMappe
//
//  Created by Antonio "Willy" Malara on 08/03/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface UilliMappeAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow          * window;
	MapViewController * mapViewController;
}

@property(nonatomic, retain) IBOutlet UIWindow          * window;
@property(nonatomic, retain) IBOutlet MapViewController * mapViewController;

@end

