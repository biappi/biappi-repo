//
//  InfoViewController.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 27/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController

- (id)init;
{
	if ((self = [super initWithNibName:nil bundle:nil]) == nil)
		return nil;
	
	self.title = @"Info";
	self.tabBarItem.image = [UIImage imageNamed:@"i.png"];
	
	return self;
}

- (void)loadView;
{
	NSData * infoPage = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"html"]];
	UIWebView * webview = [[UIWebView alloc] initWithFrame:CGRectZero];
	webview.delegate = self;
	webview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[webview loadData:infoPage MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
	self.view = webview;
	[webview release];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
	NSString * requestString = [[request URL] description];

	if ([requestString hasPrefix:@"htt"] || ([requestString hasPrefix:@"mail"]))
	{
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}

	return YES;
}

@end

