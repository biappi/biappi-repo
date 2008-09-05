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
	return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	w_KeyDidHide = YES;
	w_KeyHide = NO;
	
	usernameCell = [[PreferencesTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
	usernameCell.label.text = @"Username";
	usernameCell.textField.placeholder = @"Enter Username";
	[usernameCell.textField addTarget:self action:@selector(keyboardPleaseHide:) forControlEvents:UIControlEventEditingDidEndOnExit];
	
	passwordCell = [[PreferencesTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
	passwordCell.label.text = @"Password";
	passwordCell.textField.secureTextEntry = YES;
	passwordCell.textField.placeholder = @"Enter Password";
	[passwordCell.textField addTarget:self action:@selector(keyboardPleaseHide:) forControlEvents:UIControlEventEditingDidEndOnExit];
	
	nameCell = [[PreferencesTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
	nameCell.label.text = @"Blog Name";
	nameCell.textField.placeholder = @"Enter the Blog name";	
	[nameCell.textField addTarget:self action:@selector(keyboardPleaseHide:) forControlEvents:UIControlEventEditingDidEndOnExit];
	
	urlCell = [[PreferencesTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
	urlCell.label.text = @"API URL";
	urlCell.textField.placeholder = @"Enter API Endpoint URL";
	[urlCell.textField addTarget:self action:@selector(keyboardPleaseHide:) forControlEvents:UIControlEventEditingDidEndOnExit];
	
	idCell = [[PreferencesTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
	idCell.label.text = @"Blog ID";
	idCell.textField.placeholder = @"Enter your Blog ID";
	[idCell.textField addTarget:self action:@selector(keyboardPleaseHide:) forControlEvents:UIControlEventEditingDidEndOnExit];
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
	return (section == 0) ? @"Authorization" : @"Blog Configuration";
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
		switch (indexPath.row)
		
	{
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

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UIKeyboardWillShowNotification Callbacks

- (void)keyboardDidShow:(NSNotification *)note;
{
	NSLog([NSString stringWithFormat:@"Key Did Show - w: %@", (w_KeyDidHide) ? @"YES" : @"NO"]);
	
	if (w_KeyDidHide == NO)
		return;
	
	w_KeyDidHide = NO;
	
	CGRect kb = [[[note userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
	CGRect frame = self.view.frame;
	frame.size.height -= kb.size.height;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	self.view.frame = frame;
	[UIView commitAnimations];
}

- (void)keyboardDidHide:(NSNotification *)note;
{
	NSLog([NSString stringWithFormat:@"Key Did Show - w: %@", (w_KeyDidHide) ? @"YES" : @"NO"]);
	
	if (w_KeyDidHide == YES)
		return;
	
	w_KeyDidHide = YES;
	
	if (w_KeyHide == NO)
		return;
	
	CGRect kb = [[[note userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
	CGRect frame = self.view.frame;
	frame.size.height += kb.size.height;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	self.view.frame = frame;
	[UIView commitAnimations];
}

- (void)keyboardPleaseHide:(id)sender;
{
	w_KeyHide = YES;
}


@end

