//
//  PSFeedAdditions.m
//  FeedCouch
//
//  Created by Antonio Malara on 22/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PSEntryAdditions.h"

@implementation PSEntry (PSEntryAddition)

- (NSAttributedString *)titleAttributedString;
{
	return [self titleAttributedStringWithSizes:18 e:25];
}


- (NSAttributedString *)titleAttributedStringWithSizes:(int)uno e:(int)due;
{
	NSDictionary * firstLineAttributes  = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSColor whiteColor],
																										[NSFont fontWithName:@"Futura" size:uno],
																										nil]
																	  forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,
																										NSFontAttributeName,
																										nil]];
																										
	NSDictionary * secondLineAttributes = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSColor whiteColor],
																										[NSFont fontWithName:@"Futura" size:due],
																										nil]
																	  forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,
																										NSFontAttributeName,
																										nil]];

	NSMutableString * title = [[self.title uppercaseString] mutableCopy];
	if ([title length] > 32)
	{
		[title deleteCharactersInRange:NSMakeRange(31, [title length] - 31)];
		[title appendString:@"…"];
	}	

	NSMutableAttributedString * string;
	string = [[NSMutableAttributedString alloc] initWithString:[self.feed.title uppercaseString] attributes:firstLineAttributes];

	[string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
	[string appendAttributedString:[[NSMutableAttributedString alloc] initWithString:title attributes:secondLineAttributes]];

	return string;
}

@end
