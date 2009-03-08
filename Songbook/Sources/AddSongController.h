//
//  AddSongController.h
//  Songbook
//
//  Created by Antonio "Willy" Malara on 22/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSongController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
	UITextField * urlField;
}

- (void)setURL:(NSString  *)url;

@end
