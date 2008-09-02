//
//  AddPostMenuController.m
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 31/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AddPostMenuController.h"
#import "BlogEditorAppDelegate.h"

@implementation AddPostMenuController

- (id)initWithBlogIndex:(int)index;
{
	if ([super initWithStyle:UITableViewStyleGrouped] == nil)
		return nil;
	
	blogIndex = index;
	contentController = [[AddPostContentController alloc] init];
	self.title = @"Add Post";
	selectedSet = [[NSMutableSet alloc] init];

	return self;
}

- (void)dealloc {
	[titleField release];
	[contentController release];
	[selectedSet release];
	[super dealloc];
}

#pragma mark Actions

- (void)done;
{
	[AppDelegate createPostForBlogWithIndex:blogIndex title:titleField.text description:((UITextView *)contentController.view).text];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


- (void)cancel;
{
	UIActionSheet * ac = [[UIActionSheet alloc] initWithTitle:@"Really cancel?" delegate:self cancelButtonTitle:@"Continue Editing" destructiveButtonTitle:@"Cancel Anyway" otherButtonTitles:nil];
	[ac showInView:self.view];
	[titleField resignFirstResponder];
	[ac release];
}

#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
	if (buttonIndex == 0)
	{
		[self.parentViewController dismissModalViewControllerAnimated:YES];
	}
}


#pragma mark UIViewController Methods

- (void)viewDidLoad;
{
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)] autorelease];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)viewWillAppear:(BOOL)animated;
{
	[super viewWillAppear:animated];
		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"updatedcategories" object:[NSNumber numberWithInt:blogIndex]];
}

- (void)viewWillDisappear:(BOOL)animated;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UITableViewDataSource Protocol Methdods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	return (section == 0) ? 2 : ([[AppDelegate categoriesArrayForBlogIndex:blogIndex] count] + ((self.editing) ? 1 : 0));
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
	return (section == 0) ? @"Post" : @"Categories";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return (indexPath.section == 0) ? NO : YES;
}

#pragma mark UITableViewDelegate Protocol Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{	
	static NSString * titleCellId = @"titleCellId";
	static NSString * contentCellId = @"contentCellId";
	static NSString * categoryCellId = @"categoryCellId";
	
	NSString * identifier;
	
	if (indexPath.section == 0)
		identifier = (indexPath.row == 0) ? titleCellId : contentCellId;
	
	if (indexPath.section == 1)
		identifier = categoryCellId;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
		if (identifier == titleCellId)
		{
			cell.text = @"Title";
			titleField = [[UITextField alloc] initWithFrame:CGRectMake(60, 11, 238, 50)];
			titleField.placeholder = @"Insert title here";
			titleField.delegate = self;
			[titleField addTarget:self action:@selector(editingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
			[titleField addTarget:self action:@selector(editingDidEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
			[cell.contentView addSubview:titleField];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		} else if (identifier == contentCellId) {
			cell.text = @"Content";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	}

	if (indexPath.section == 1)
	{
		cell.text = [[[AppDelegate categoriesArrayForBlogIndex:blogIndex] objectAtIndex:indexPath.row] valueForKey:@"description"];
		if ([selectedSet member:indexPath] != nil)
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		else
			cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	[tableView deselectRowAtIndexPath:indexPath animated:((indexPath.section == 0 && indexPath.row == 1) || ((indexPath.section == 1) && (indexPath.row == [[AppDelegate categoriesArrayForBlogIndex:blogIndex] count])))];
	
	if (!(indexPath.row == 0 && indexPath.section == 0))
		[titleField resignFirstResponder];		

	if (indexPath.section == 0 && indexPath.row == 1)
	{
		contentController.title = ([titleField.text length] == 0) ? @"Untitled Post" : titleField.text;
		[self.navigationController pushViewController:contentController animated:YES];
	}
		
	if (indexPath.section == 1)
	{				
		id obj = [selectedSet member:indexPath];
		
		if (obj != nil)
			[selectedSet removeObject:obj];
		else
			[selectedSet addObject:indexPath];
		
		[self.tableView reloadData];
	}
}

#pragma mark UITextFieldDelegate Methods

- (void)editingDidEnd:(id)sender;
{
	[sender resignFirstResponder];
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

- (void)reload:(NSNotification *)noti;
{
	[self.tableView reloadData];
}

@end

