//
//  BlogUpdaterConnectionDelegate.m
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 28/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BlogUpdaterConnectionDelegate.h"
#import "XMLRPCParser.h"
#import "BlogEditorAppDelegate.h"
#import "page.h"

@implementation BlogUpdaterConnectionDelegate

- (id)initWithBlogIndex:(int)i;
{
	if ([super init] == nil)
		return nil;
	
	blogIndex = i;
	receiveddata = [[NSMutableData alloc] init];
	
	return self;
}

- (void)dealloc;
{
	[receiveddata release];
	[super dealloc];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    [receiveddata setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    [receiveddata appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
	NSString * t = [[NSString alloc] initWithData:receiveddata encoding:NSUTF8StringEncoding];
	NSLog(t);
	[t release];
	
	[AppDelegate setValue:[XMLRPCParser decodeData:receiveddata] forBlogWithIndex:blogIndex];	
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"updatedblog" object:[NSNumber numberWithInt:blogIndex]]];
	[connection release];
	NSLog(@"conn did fin laod");
} 

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
	UIAlertView * alert = [UIAlertView alloc];
	[alert initWithTitle:@"A Network error Occurred" message:[error description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	[alert show];
	[alert autorelease];
	[connection release];
}

@end
