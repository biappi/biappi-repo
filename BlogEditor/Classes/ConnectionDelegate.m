//
//  ConnectionDelegate.m
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 28/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ConnectionDelegate.h"
#import "XMLRPCParser.h"
#import "BlogEditorAppDelegate.h"

@implementation ConnectionDelegate

- (id)init;
{
	if ([super init] == nil)
		return nil;
	
	receiveddata = [[NSMutableData alloc] init];
	
	return self;
}

- (id)initWithTarget:(id)aTarget action:(SEL)anAction userInfo:(id)aInfo;
{
	if ([super init] == nil)
		return nil;
	
	receiveddata = [[NSMutableData alloc] init];
	target = aTarget;
	action = anAction;
	info = [aInfo retain];
	
	return self;
}
- (void)dealloc;
{
	NSLog(@"CD dealloc");
	[receiveddata release];
	[info release];
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
	id value = [XMLRPCParser decodeData:receiveddata];
	NSLog([value description]);
 
	NSString * t = [[NSString alloc] initWithData:receiveddata encoding:NSUTF8StringEncoding];
	NSLog(t);
	[t release];
 	
	[connection release];
	NSLog(@"XXX conn did fin laod");
	
	[target performSelector:action withObject:value withObject:info];
} 

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
	
	NSString * t = [[NSString alloc] initWithData:receiveddata encoding:NSUTF8StringEncoding];
	NSLog(t);
	[t release];
	
	[connection release];
	
	NSLog(@"XXXX connDid alsdjfhladjfhlsdf fail");
}

@end
