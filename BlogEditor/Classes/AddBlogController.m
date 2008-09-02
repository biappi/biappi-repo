//
//  AddBlogController.m
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 28/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AddBlogController.h"
#import "BlogEditorAppDelegate.h"

@implementation AddBlogController

- (id)init;
{
	return [super initWithNibName:@"AddBlog" bundle:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	usernameCell = [[PreferencesTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
	usernameCell.label.text = @"Username";
	usernameCell.textField.placeholder = @"Enter Username";
	
	passwordCell = [[PreferencesTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
	passwordCell.label.text = @"Password";
	passwordCell.textField.secureTextEntry = YES;
	passwordCell.textField.placeholder = @"Enter Password";

	nameCell = [[PreferencesTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
	nameCell.label.text = @"Blog Name";
	nameCell.textField.placeholder = @"Enter the Blog name";	
	
	urlCell = [[PreferencesTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
	urlCell.label.text = @"API URL";
	urlCell.textField.placeholder = @"Enter API Endpoint URL";

	idCell = [[PreferencesTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
	idCell.label.text = @"Blog ID";
	idCell.textField.placeholder = @"Enter your Blog ID";
}

- (void)dealloc {
	[usernameCell release];
	[passwordCell release];
	[nameCell release];
	[urlCell release];
	[idCell release];
	[super dealloc];
}

- (IBAction)save;
{
	BlogEditorAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	/*
	NSURL * endpoint = [NSURL URLWithString:urlCell.textField.text];
	if (endpoint == nil)
	{
		UIAlertView * alert = [UIAlertView alloc];
		[alert initWithTitle:@"Malformed URL" message:@"The url you've entered appears to be incorrect, please check it" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[alert show];
		[alert autorelease];
		return;
	}
	*/
	
	[appDelegate addBlogAtURL:urlCell.textField.text withID:idCell.textField.text name:nameCell.textField.text username:usernameCell.textField.text andPassword:passwordCell.textField.text];	
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel;
{
	usernameCell.textField.text = @"";
	passwordCell.textField.text = @"";
	nameCell.textField.text = @"";
	urlCell.textField.text = @"";
	idCell.textField.text = @"";
	
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
	switch (section)
	{
		case 0:
			return @"Authorization";
		case 1:
			return @"Blog Configuration";
	}
	
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
{
	return (section == 1) ? @"Please refer to your Blog Service Provider or your Blog configuration for these settings.": nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	return (section == 0) ? 2 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	if (indexPath.section == 1)
		switch (indexPath.row) {
			case 0: return nameCell; break;
			case 1: return urlCell; break;
			case 2: return idCell; break;
		}
	return (indexPath.row == 0) ? usernameCell : passwordCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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

