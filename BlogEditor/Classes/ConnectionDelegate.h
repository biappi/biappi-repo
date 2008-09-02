//
//  ConnectionDelegate.h
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 28/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionDelegate : NSObject
{
	NSMutableData * receiveddata;
	id target;
	SEL action;
	id info;
}

- (id)initWithTarget:(id)aTarget action:(SEL)anAction userInfo:(id)info;

@end
