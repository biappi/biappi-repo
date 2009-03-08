//
//  MainTabController.h
//  Songbook
//
//  Created by Antonio "Willy" Malara on 21/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatingTabBarController.h"

@interface MainTabController : RotatingTabBarController
{
}

- (void)presentAddSongWithURL:(NSString *)url;

@end
