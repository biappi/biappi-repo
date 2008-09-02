//
//  PostsListController.m
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 28/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PostsListController.h"
#import "BlogEditorAppDelegate.h"
#import "ViewPost.h"
#import "AddPostMenuController.h"

@implementation PostsListController

- (id)initWithBlogIndex:(int)bix;
{
	if ([super initWithNibName:@"PostsList" bundle:nil] == nil)
		return nil;
	
	blogIndex = bix;
	
	return self;
}

- (void)viewDidLoad;
{
	[super viewDidLoad];
	self.title = [[AppDelegate.blogs objectAtIndex:blogIndex] objectForKey:@"name"];
	self.navigationItem.rightBarButtonItem = plusSign;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)dealloc;
{
	[super dealloc];
}

- (IBAction)newPost;
{
	/*
	EditPost * new = [[EditPost alloc] initWithBlogIndex:blogIndex postIndex:-1];
	[self.navigationController presentModalViewController:new animated:YES];
	[new release];
	 */
	[self.navigationController presentModalViewController:[[[UINavigationController alloc] initWithRootViewController:[[[AddPostMenuController alloc] initWithBlogIndex:blogIndex] autorelease]] autorelease] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	// OK if it's nil, boom if it's not an array
	return [[AppDelegate getValueForBlogWithIndex:blogIndex] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	cell.text = [[[AppDelegate getValueForBlogWithIndex:blogIndex] objectAtIndex:indexPath.row] objectForKey:@"title"];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	ViewPost * new = [[ViewPost alloc] initWithBlogIndex:blogIndex postIndex:indexPath.row];
	[self.navigationController pushViewController:new animated:YES];
	[new release];
}

- (void)viewWillAppear:(BOOL)animated;
{
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedBlog:) name:@"updatedblog" object:[NSNumber numberWithInt:blogIndex]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning;
{
	[super didReceiveMemoryWarning];
}

- (void)updatedBlog:(NSNotification *)note;
{
	NSLog(@"updatedblog");
	[self.tableView reloadData];
	NSLog(@"Reload");
}

@end

