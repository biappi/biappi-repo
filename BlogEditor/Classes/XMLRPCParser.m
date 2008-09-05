//
//  XMLRPCParser.m
//  Untitled
//
//  Created by Antonio "Willy" Malara on 17/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "XMLRPCParser.h"

@implementation XMLRPCParser

+ (id)decodeData:(NSData *)someData;
{
	XMLRPCParser * p = [[XMLRPCParser alloc] init];
	id returnValue = [p parseData:someData];
	[p release];
	
	return returnValue;
}

- (id)parseData:(NSData *)someData;
{
	NSXMLParser * parser;
	
	frameStack = [[NSMutableArray array] retain];
	[frameStack addObject:[NSMutableDictionary dictionaryWithObject:@"Yeah" forKey:@"workingObject"]];

	parser = [[NSXMLParser alloc] initWithData:someData];
	[parser setDelegate:self];
	[parser parse];
	[parser release];

	return [[frameStack lastObject] objectForKey:@"value"];
}

- (void)dealloc;
{
	[frameStack release];
	[super dealloc];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict;
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSMutableDictionary * frame = [NSMutableDictionary dictionary];

	if ([elementName isEqualToString:@"array"])
	{
		[frame setObject:@"array" forKey:@"workingObject"];
		[frame setObject:[[NSMutableArray array] retain] forKey:@"array"];
		[frameStack addObject:frame];
	}
	
	if ([elementName isEqualToString:@"value"])
	{
		[frame setObject:@"value" forKey:@"workingObject"];
		[frameStack addObject:frame];
		[data release];
		data = nil;
	}
	
	if ([elementName isEqualToString:@"string"])
	{
		[frame setObject:@"string" forKey:@"workingObject"];
		[frameStack addObject:frame];
		[data release];
		data = nil;
	}
	
	if ([elementName isEqualToString:@"struct"])
	{
		[frame setObject:@"struct" forKey:@"workingObject"];
		[frame setObject:[[NSMutableDictionary dictionary] retain] forKey:@"struct"];
		[frameStack addObject:frame];
	}
	
	if ([elementName isEqualToString:@"member"])
	{
		[frame setObject:@"member" forKey:@"workingObject"];
		[frameStack addObject:frame];
	}
	
	if ([elementName isEqualToString:@"name"])
	{
		[frame setObject:@"name" forKey:@"workingObject"];
		[frameStack addObject:frame];
		[data release];
		data = nil;
	}

	[pool release];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	if ([elementName isEqualToString:@"string"])
	{
		[frameStack removeLastObject];
		
		[[frameStack lastObject] setObject:((data == nil) ? [NSString string] : data) forKey:@"returnValue"];
		
		[data release];
		data = nil;
	}
	
	if ([elementName isEqualToString:@"value"])
	{
		id returnValue = [[[frameStack lastObject] objectForKey:@"returnValue"] retain];
		[frameStack removeLastObject];
		
		if (returnValue == nil)
		{
			returnValue = [data retain];
			[data release];
			data = nil;
		}
		
		// NSLog([NSString stringWithFormat:@"%d\n", [frameStack count]]);
		
		if ([[[frameStack lastObject] objectForKey:@"workingObject"] isEqualToString:@"array"])
		{
			[[[frameStack lastObject] objectForKey:@"array"] addObject:returnValue];
		}
		
		if ([[[frameStack lastObject] objectForKey:@"workingObject"] isEqualToString:@"member"] ||
			[[[frameStack lastObject] objectForKey:@"workingObject"] isEqualToString:@"Yeah"])
		{
			[[frameStack lastObject] setObject:returnValue forKey:@"value"];
		}

		// if ([frameStack count] == 0)
		//	NSLog ([returnValue description]);
	}
	
	if ([elementName isEqualToString:@"array"])
	{
		NSArray * returnValue = [[frameStack lastObject] objectForKey:@"array"];
		[frameStack removeLastObject];
		if ([frameStack count] > 0)
			[[frameStack lastObject] setObject:returnValue forKey:@"returnValue"];
		// else
		//	NSLog ([returnValue description]);
	}
	
	if ([elementName isEqualToString:@"name"])
	{
		[frameStack removeLastObject];
		[[frameStack lastObject] setObject:[data retain] forKey:@"name"];
		[data release];
		data = nil;
	}
	
	if ([elementName isEqualToString:@"member"])
	{
		NSString * name = [[frameStack lastObject] objectForKey:@"name"];
		id value = [[frameStack lastObject] objectForKey:@"value"];
		[frameStack removeLastObject];
		[[[frameStack lastObject] objectForKey:@"struct"] setObject:value forKey:name];
	}
	
	if ([elementName isEqualToString:@"struct"])
	{
		NSArray * returnValue = [[frameStack lastObject] objectForKey:@"struct"];
		[frameStack removeLastObject];
		if ([frameStack count] > 0)
			[[frameStack lastObject] setObject:returnValue forKey:@"returnValue"];
		// else
		//	NSLog ([returnValue description]);
	}
	
	[pool release];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
{
	if (data == nil)
		data = [[NSMutableString string] retain];
	
	[data appendString:string];
}

@end
