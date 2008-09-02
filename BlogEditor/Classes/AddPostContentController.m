//
//  AddPostContentController.m
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 01/09/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AddPostContentController.h"

@implementation AddPostContentController

- (id)init;
{
	if ([super initWithNibName:nil bundle:nil] == nil)
		return nil;
	
	return self;
}

- (void)loadView;
{
	self.view = [[UITextView alloc] initWithFrame:CGRectZero];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[(UITextView *)self.view setFont:[UIFont fontWithName:@"Helvetica" size:20]];
}

- (void)viewWillAppear:(BOOL)animated;
{
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];	
}

- (void)viewWillDisappear:(BOOL)animated;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
	return (interfaceOrientation != UIInterfaceOrientationPortrait);
}

#pragma mark UIKeyboardWillShowNotification Callbacks

- (void)keyboardWillShow:(NSNotification *)note;
{
	CGRect kb = [[[note userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
	CGRect frame = self.view.frame;
	frame.size.height -= kb.size.height;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	self.view.frame = frame;
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)note;
{
	CGRect kb = [[[note userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
	CGRect frame = self.view.frame;
	frame.size.height += kb.size.height;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	self.view.frame = frame;
	[UIView commitAnimations];
}

@end
