//
//  PRODownloader.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 24/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PRODownloader.h"
#import "PRO2HTML.h"
#import <regex.h>

NSDictionary * parseFileAtUrl(NSString * urlString)
{
	NSURL * url = [NSURL URLWithString:urlString];

	NSMutableDictionary * dotPro = [NSMutableDictionary dictionaryWithCapacity:3];
	
	if (url == nil)
		return [NSDictionary dictionaryWithObject:@"Text you've entered does not looks like a URL" forKey:@"error"];
	
	NSStringEncoding enc;
	NSError * error = nil;
	NSString  * htmlFile = [NSString stringWithContentsOfURL:url usedEncoding:&enc error:&error];

	if ([error code] == 264)
	{
		error = nil;
		htmlFile = [NSString stringWithContentsOfURL:url encoding:NSISOLatin1StringEncoding error:&error];
	}

	if (error != nil)
		return [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Cannot download the file from internet (%@)", [error description]] forKey:@"error"];
	
	htmlFile = [NSString stringWithFormat:@"%@\n", htmlFile];
	
	
	NSInteger   result;
	
	static regex_t * dotProFinder = nil;
	if (dotProFinder == nil)
	{
		dotProFinder = malloc(sizeof(regex_t));
		result = regcomp(dotProFinder, "{(title|subtitle|t|su|start_of_chorus|soc|end_of_chorus|eoc|comment|c|start_of_tab|sot|end_of_tab|eot) *: *([^}]*)}", REG_EXTENDED);
		NSCAssert(result == 0, @"Failed to compile dotProFinder regexp");
	}
		
	regmatch_t firstProMarker[1];
	result = regexec(dotProFinder, [htmlFile UTF8String], 1, firstProMarker, 0);
	
	if (result == REG_NOMATCH)
	{
		return [NSDictionary dictionaryWithObject:@"The file downloaded seems to be not a .pro file" forKey:@"error"];
	}
	
	static regex_t * closedHtmlFinder = nil;
	if (closedHtmlFinder == nil)
	{
		closedHtmlFinder = malloc(sizeof(regex_t));
		result = regcomp(closedHtmlFinder, "</[^>]+>", REG_EXTENDED);
		NSCAssert(result == 0, @"Failed to compile closedHtmlFinder regexp");
	}	
	
	regmatch_t closedHtmlTag[1];
	result = regexec(closedHtmlFinder, [htmlFile UTF8String] + firstProMarker[0].rm_eo, 1, closedHtmlTag, REG_EXTENDED);
	
	if (result == 0)
	{
		[dotPro setObject:[htmlFile substringWithRange:NSMakeRange(firstProMarker[0].rm_so,
																  (firstProMarker[0].rm_eo + closedHtmlTag[0].rm_so) - firstProMarker[0].rm_so)]
				   forKey:@"chords"];
	}
	else if (result == REG_NOMATCH)
	{
		[dotPro setObject:[htmlFile substringFromIndex:firstProMarker[0].rm_so] forKey:@"chords"];
	}

	[dotPro setObject:parseTitle(htmlFile) forKey:@"title"];
	[dotPro setObject:parseSubTitle(htmlFile) forKey:@"artist"];
	
	return dotPro;
}
