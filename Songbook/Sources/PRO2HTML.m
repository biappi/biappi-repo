//
//  PRO2HTML.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 24/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PRO2HTML.h"
#import <regex.h>
#import "RegexKitLite.h"

void zapTitleAndSubtitle(NSMutableString * pro)
{
	[pro replaceOccurrencesOfRegex:@"\\{(subtitle|st|title|t)\\s*:\\s*([^\\}]*)\\}" withString:@""];
}

NSString * parseTitle(NSString * html)
{
	return [html stringByMatching:@"\\{(title|t)\\s*:\\s*([^\\}]*)\\}" capture:2];
}

NSString * parseSubTitle(NSString * html)
{
	return [html stringByMatching:@"\\{(subtitle|st)\\s*:\\s*([^\\}]*)\\}" capture:2];
}

void zapSubTitle(NSMutableString * html, BOOL r)
{
	parseSubTitle(html);
}

static void zapCommands(NSMutableString * html)
{	
	[html replaceOccurrencesOfRegex:@"\\{[^\\}]*\\}" withString:@""];
}

static NSMutableString * paragrafate(NSString * html)
{
	NSMutableString * result = [NSMutableString string];

	BOOL openedWhitespace = NO;
	BOOL inWhitespace     = NO;

	NSRange   iterator  = NSMakeRange(0, 0);
	NSInteger length    = [html length];

	while (iterator.location + iterator.length < length)
	{
		NSRange lineRange = [html lineRangeForRange:iterator];
		
		iterator.location = lineRange.location + lineRange.length;

		NSString * line = [html substringWithRange:lineRange];
		
		if ([[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""])
		{
			if (inWhitespace == NO)
			{
				if (openedWhitespace == YES)
				{
					[result appendString:@"</p>\n"];	
					openedWhitespace == NO;
				}				
				
				inWhitespace = YES;
				[result appendString:@"<p>\n"];
				openedWhitespace = YES;
			}
		} else {
			inWhitespace = NO;
			if ([line hasPrefix:@"#"] == NO)
			{
				NSRange found = [line rangeOfString:@"span class=\"chords"];
				
				if (openedWhitespace == YES)
					if (found.location == NSNotFound)
						[result appendString:@"<span class=\"nochordverse\">"];
					else
						[result appendString:@"<span class=\"verse\">"];
				
				[result appendString:[line stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]];

				if (openedWhitespace == YES)
					[result appendString:@"</span>\n"];
				else
					[result appendString:@"\n"];
			}
		}
	}
	
	if (openedWhitespace == YES)
	{
		[result appendString:@"</p>"];	
		openedWhitespace == NO;
	}	
	
	return result;
}

static void chorussify(NSMutableString * html)
{
	[html replaceOccurrencesOfRegex:@"\\{(start_of_chorus|soc)\\}" withString:@"<div class=\"chorus\">"];
	[html replaceOccurrencesOfRegex:@"\\{(end_of_chorus|eoc)\\}" withString:@"</div>"];
}

static void commentify(NSMutableString * html)
{
	[html replaceOccurrencesOfRegex:@"\\{(comment|c)\\s*:\\s*([^\\}]*)\\}" withString:@"<span class=\"comment\">$2</span>"];
}

static void substituteChords(NSMutableString * html)
{
	[html replaceOccurrencesOfRegex:@"(\\[([^\\]]+)\\])\\s*(\\[([^\\]]+)\\])" withString:@"$1 &nbsp; &nbsp; &nbsp; &nbsp; $3"];
	[html replaceOccurrencesOfRegex:@"(\\[([^\\]]+)\\])\\s*(\\[([^\\]]+)\\])" withString:@"$1 &nbsp; &nbsp; &nbsp; &nbsp; $3"];
		
	[html replaceOccurrencesOfRegex:@"\\[([^\\]]+)\\]" withString:@"<span class=\"mark\"><span class=\"chords\">$1</span></span>"];
}

NSString * parsePROToHTML(NSString * pro)
{
	NSMutableString * html = nil;
	html = [NSMutableString stringWithString:pro];
	
	NSString * title  = parseTitle(html);
	NSString * artist = parseSubTitle(html);
	
	chorussify(html);
	commentify(html);
	zapCommands(html);
	
	substituteChords(html);
		
	html = paragrafate(html);
	
	html = [NSString stringWithFormat:@"<style>"
									   ".verse        {position: relative; display: block; line-height: 2.5}"
									   ".nochordverse {position: relative; display: block; line-height: 1}"
									   ".mark         {position: absolute;}"
									   ".chords       {position: relative; top:-1em;}"
									   "body          {font-family: sans-serif;}"
									   ".title        {margin-bottom: 0px; font-size: 24}"
									   ".subtitle     {margin-top: 0px; margin-bottom:40px; font-weight: normal; font-size:18}"
									   ".chords       {font-weight: bold; font-size: small;}"
									   ".chorus       {padding-top: 1em; padding-left:30px; background:#DDDDDD;}"
									   ".comment      {color: gray; font-style: italic; line-height: 2.5}"
									   "</style>"
	/*
									   "<script>"
									   "var ival; "
									   "function scrollCB() { window.scrollBy(0,1); if ((window.pageYOffset + window.innerHeight) == document.body.clientHeight) clearInterval(ival);}"
									   "</script>"
									   "<div onclick=\"window.location='biappi-click:'\">"
	 */
									   "<h1 class=\"title\">%@</h1>"
									   "<h2 class=\"subtitle\">%@</h2>"
									   "%@",
	//								   "</div>",
									   title,
									   artist,
									   html];

	return html;
}
