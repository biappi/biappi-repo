//
//  RotatingTabBarController.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 19/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RotatingTabBarController.h"

@implementation RotatingTabBarController

@synthesize rotateEnabled;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
	return (rotateEnabled) ? (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown)
						   : (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
