//
//  MyStubs.m
//  ReverserBench
//
//  Created by Antonio "Willy" Malara on 25/08/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MyStubs.h"


@implementation MyClass

- (id)initWithName:(NSString *)aName andChilds:(NSArray *)someChilds
{
	if ((self = [super init]) == nil)
		return nil;
	
	name = [aName retain];
	childs = [someChilds retain];
	
	return self;
}


- (void)dealloc
{
	[childs release];
	[name release];
	[super dealloc];
}

- (BOOL)leaf
{
	return NO;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@> %@: %@", NSStringFromClass([self class]), name, [childs description]];
}

- (NSString *)name
{
	return name;
}

- (NSString *)valueForUndefinedKey:(NSString *)key
{
	return [NSString stringWithFormat:@"Class %@: undefined key %@", NSStringFromClass([self class]), key];
}

@end

@implementation MyMethod

- (id)initWithName:(NSString *)aName
{
	if ((self = [super init]) == nil)
		return nil;
	
	name = [aName retain];
	
	return self;
}


- (void)dealloc {
	[childs release];
	[super dealloc];
}

- (BOOL)leaf
{
	return YES;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@> %@", NSStringFromClass([self class]), name];
}

- (NSString *)valueForUndefinedKey:(NSString *)key
{
	return [NSString stringWithFormat:@"Class %@: undefined key %@", NSStringFromClass([self class]), key];
}

@end
