//
//  EditSongController.h
//  Songbook
//
//  Created by Antonio "Willy" Malara on 22/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSongController : UIViewController <UIActionSheetDelegate>
{
	IBOutlet UITextField     * artistField;
	IBOutlet UITextField     * titleField;
	IBOutlet UITextView      * songText;
	
	IBOutlet UITableViewCell * artistCell;
	IBOutlet UITableViewCell * titleCell;
	
	NSInteger       songID;
}

- (id)initWithSongID:(NSInteger)theSong;

@end
