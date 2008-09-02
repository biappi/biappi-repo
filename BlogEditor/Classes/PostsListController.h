//
//  PostsListController.h
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 28/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsListController : UITableViewController
{
	int blogIndex;
	IBOutlet UIBarButtonItem * plusSign;
	IBOutlet UILabel * statusBar;
	IBOutlet UIActivityIndicatorView * activity;
}

- (id)initWithBlogIndex:(int)bix;
- (IBAction)newPost;
// - (IBAction)refresh;

@end
