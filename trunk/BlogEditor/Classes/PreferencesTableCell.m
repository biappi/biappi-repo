//
//  PreferencesTableCell.m
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 28/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PreferencesTableCell.h"

@implementation PreferencesTableCell

@synthesize label;
@synthesize textField;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
{
	if ([super initWithFrame:frame reuseIdentifier:reuseIdentifier] == nil)
		return nil;

	label = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, 87, 31)];
	[self addSubview:label];
	
	textField = [[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 25)];
	[textField addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventEditingDidEndOnExit];
	[self addSubview:textField];
	
	return self;
}

- (void)dealloc;
{
	[label release];
	[textField release];
	[super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	// Intentionally blank
}

- (void)endEditing;
{
	[textField resignFirstResponder];
}

@end
