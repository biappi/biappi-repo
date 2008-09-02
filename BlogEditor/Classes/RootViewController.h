//
//  RootViewController.h
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 17/08/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController
{
	IBOutlet UIBarButtonItem * plusSign;
	IBOutlet UINavigationController * addBlogViewController;
}

- (IBAction)addBlog;

@end
