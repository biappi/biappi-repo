//
//  RotatingTabBarController.h
//  Songbook
//
//  Created by Antonio "Willy" Malara on 19/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotatingTabBarController : UITabBarController
{
	BOOL rotateEnabled;
}

@property(nonatomic, assign, getter=isRotateEnabled) BOOL rotateEnabled;

@end
