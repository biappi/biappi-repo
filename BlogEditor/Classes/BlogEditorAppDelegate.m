//
//  BlogEditorAppDelegate.m
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 17/08/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "BlogEditorAppDelegate.h"
#import "RootViewController.h"
#import "RequestStrings.h"
#import "BlogUpdaterConnectionDelegate.h"
#import "ConnectionDelegate.h"
#import "StringEscaping.h"

@implementation BlogEditorAppDelegate

@synthesize blogs;
@synthesize window;
@synthesize navigationController;

- (id)init;
{
	if ([super init] == nil)
		return nil;
	
	blogCategories = [[NSMutableDictionary alloc] init];
	blogValues = [[NSMutableDictionary alloc] init];
	blogs = [[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"blogs"]] retain];
	if (blogs == nil)
		blogs = [[NSMutableArray array] retain];

	//for (int i = 0; i < [blogs count]; i++)
	//	[self updateBlogWithIndex:i];
	
	return self;
}

- (void)dealloc;
{
	[navigationController release];
	[blogValues release];
	[blogs release];
	[window release];
	[super dealloc];
}

- (void)addBlogAtURL:(NSString *)endpoint withID:(NSString *)anID name:(NSString *)name username:(NSString *)anUsername andPassword:(NSString *)aPass;
{
	[blogs addObject:[NSDictionary dictionaryWithObjectsAndKeys:endpoint, @"endpoint", anID, @"id", name, @"name", anUsername, @"username", aPass, @"password", nil]];
	[[NSUserDefaults standardUserDefaults] setObject:blogs forKey:@"blogs"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeBlogWithIndex:(int)idx;
{
	[blogs removeObjectAtIndex:idx];
	[blogValues removeObjectForKey:[NSString stringWithFormat:@"%d", idx]];
	[[NSUserDefaults standardUserDefaults] setObject:blogs forKey:@"blogs"];
}

- (void)updateBlogWithIndex:(int)blogIndex;
{
	NSString * request = [NSString stringWithFormat:getRecentPosts, [[blogs objectAtIndex:blogIndex] objectForKey:@"id"], [[blogs objectAtIndex:blogIndex] objectForKey:@"username"], [[blogs objectAtIndex:blogIndex] objectForKey:@"password"], nil];
	NSURL * url = [NSURL URLWithString:[[blogs objectAtIndex:blogIndex] objectForKey:@"endpoint"]];
	
	NSMutableURLRequest * req;
	req = [NSMutableURLRequest requestWithURL:url];
	req.HTTPMethod = @"POST";
	req.HTTPBody = [request dataUsingEncoding:NSUTF8StringEncoding];
	
	NSLog(request);
	
	[[NSURLConnection alloc] initWithRequest:req delegate:[[[BlogUpdaterConnectionDelegate alloc] initWithBlogIndex:blogIndex] autorelease]];
}

- (void)setValue:(id)value forBlogWithIndex:(int)idx;
{
	NSLog([value description]);
	[blogValues setValue:value forKey:[NSString stringWithFormat:@"%d", idx]];
}

- (id)getValueForBlogWithIndex:(int)idx;
{
	id value = [blogValues objectForKey:[NSString stringWithFormat:@"%d", idx]];
	if (value == nil)
		[self updateBlogWithIndex:idx];
	
	if ([value isKindOfClass:[NSDictionary class]])
		return nil;
	
	return value;
}

- (void)createPostForBlogWithIndex:(int)blogIndex title:(NSString *)aTitle description:(NSString *)theDescription;
{
	NSString * _id = [[blogs objectAtIndex:blogIndex] objectForKey:@"id"];
	NSString * _user = [[blogs objectAtIndex:blogIndex] objectForKey:@"username"];
	NSString * _pass = [[blogs objectAtIndex:blogIndex] objectForKey:@"password"];
	
	NSString * temp = AutoreleasedCloneForXML(theDescription, YES);
	
	NSString * request = [NSString stringWithFormat:newPost, _id, _user, _pass, temp, aTitle, nil];
	NSLog(request);
	NSURL * url = [NSURL URLWithString:[[blogs objectAtIndex:blogIndex] objectForKey:@"endpoint"]];
	
	NSMutableURLRequest * req;
	req = [NSMutableURLRequest requestWithURL:url];
	req.HTTPMethod = @"POST";
	req.HTTPBody = [request dataUsingEncoding:NSUTF8StringEncoding];
	[[NSURLConnection alloc] initWithRequest:req delegate:[[[ConnectionDelegate alloc] init] autorelease]];
	
	[blogValues removeObjectForKey:[NSString stringWithFormat:@"%d", blogIndex]];
}

- (void)modifyPostWithIndex:(int)postIndex forBlogWithIndex:(int)blogIndex title:(NSString *)aTitle description:(NSString *)theDescription;
{
	
}

- (NSArray *)categoriesArrayForBlogIndex:(int)blogIndex;
{
	id value = [blogCategories objectForKey:[NSString stringWithFormat:@"%d", blogIndex]];
	if (value != nil)
		return value; 
	
	NSString * _id = [[blogs objectAtIndex:blogIndex] objectForKey:@"id"];
	NSString * _user = [[blogs objectAtIndex:blogIndex] objectForKey:@"username"];
	NSString * _pass = [[blogs objectAtIndex:blogIndex] objectForKey:@"password"];
	
	NSString * request = [NSString stringWithFormat:getCategories, _id, _user, _pass, nil];
	NSLog(request);
	NSURL * url = [NSURL URLWithString:[[blogs objectAtIndex:blogIndex] objectForKey:@"endpoint"]];
	
	NSMutableURLRequest * req;
	req = [NSMutableURLRequest requestWithURL:url];
	req.HTTPMethod = @"POST";
	req.HTTPBody = [request dataUsingEncoding:NSUTF8StringEncoding];
	
	ConnectionDelegate * cd = [[ConnectionDelegate alloc] initWithTarget:self action:@selector(categoriesCallback:info:) userInfo:[NSNumber numberWithInt:blogIndex]];
	[cd autorelease];
	
	[[NSURLConnection alloc] initWithRequest:req delegate:cd];
	
	return nil;
}

- (void)categoriesCallback:(id)value info:(id)num;
{
	[blogCategories setObject:value forKey:[NSString stringWithFormat:@"%d", [num intValue]]];
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"updatedcategories" object:num]];
}

- (void)toggleToolbar;
{
	toolbar.hidden = !toolbar.hidden;
	
	CGRect frame = navigationController.view.frame;
	frame.size.height += toolbar.bounds.size.height * ((toolbar.hidden) ? -1 : +1);
	navigationController.view.frame = frame;
}


- (void)hideToolbar;
{
	if (toolbar.hidden == YES)
		return;
	
	toolbar.hidden = YES;
	
	CGRect frame = navigationController.view.frame;
	frame.size.height += toolbar.bounds.size.height * ((toolbar.hidden) ? -1 : +1);
	navigationController.view.frame = frame;
}

- (void)showToolbar;
{
	if (toolbar.hidden == YES)
		return;
		
	toolbar.hidden = YES;
	
	CGRect frame = navigationController.view.frame;
	frame.size.height += toolbar.bounds.size.height * ((toolbar.hidden) ? -1 : +1);
	navigationController.view.frame = frame;
}

#pragma mark Application Housekeeping

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// Configure and show the window
		
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}

@end
