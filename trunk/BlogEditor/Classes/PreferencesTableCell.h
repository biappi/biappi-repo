//
//  UIPreferencesTableCell.h
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 28/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferencesTableCell : UITableViewCell
{
	UILabel * label;
	UITextField * textField;
}

@property(readonly, nonatomic) UILabel * label;
@property(readonly, nonatomic) UITextField * textField;

@end
