//
//  AddBlogController.h
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 28/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferencesTableCell.h"

@interface AddBlogController : UITableViewController
{
	PreferencesTableCell * usernameCell;
	PreferencesTableCell * passwordCell;
	PreferencesTableCell * nameCell;
	PreferencesTableCell * urlCell;
	PreferencesTableCell * idCell;
	
	bool w_KeyDidHide;
	// bool w_KeyHide;
	CGFloat w_KeyHeight;
}

+ (AddBlogController *)addBlogController;

- (IBAction)save;
- (IBAction)cancel;

@end
