//
//  BlogUpdaterConnectionDelegate.h
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 28/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlogUpdaterConnectionDelegate : NSObject
{
	int blogIndex;
	NSMutableData * receiveddata;
}

- (id)initWithBlogIndex:(int)i;

@end
