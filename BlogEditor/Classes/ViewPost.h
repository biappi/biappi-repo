//
//  ViewPost.h
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 28/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewPost : UIViewController
{
	int blogIndex;
	int postIndex;
}

- (id)initWithBlogIndex:(int)bix postIndex:(int)pix;

@end
