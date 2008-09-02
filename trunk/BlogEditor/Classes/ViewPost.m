//
//  ViewPost.m
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 28/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ViewPost.h"
#import "RequestStrings.h"
#import "BlogEditorAppDelegate.h"

@implementation ViewPost

- (id)initWithBlogIndex:(int)bix postIndex:(int)pix;
{
	if ([super initWithNibName:@"ViewPost" bundle:nil] == nil)
		return nil;
	
	blogIndex = bix;
	postIndex = pix;
	
	return self;
}


- (void)loadView;
{
	self.title = [[[AppDelegate getValueForBlogWithIndex:blogIndex] objectAtIndex:postIndex] objectForKey:@"title"];
	
	UIWebView * w = [[UIWebView alloc] init];
	[w loadHTMLString:[NSString stringWithFormat:pageTemplate, [[[AppDelegate getValueForBlogWithIndex:blogIndex] objectAtIndex:postIndex] objectForKey:@"description"]] baseURL:[NSURL URLWithString:[[[AppDelegate getValueForBlogWithIndex:blogIndex] objectAtIndex:postIndex] objectForKey:@"permaLink"]]];
	
	self.view = w;
	[w release];
}

- (void)dealloc;
{
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

@end
