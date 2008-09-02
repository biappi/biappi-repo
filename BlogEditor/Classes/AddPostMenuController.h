//
//  AddPostMenuController.h
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 31/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPostContentController.h"

@interface AddPostMenuController : UITableViewController <UITextFieldDelegate, UIActionSheetDelegate>
{
	UITextField * titleField;
	AddPostContentController * contentController;
	int blogIndex;
	NSMutableSet * selectedSet;
}

@end
