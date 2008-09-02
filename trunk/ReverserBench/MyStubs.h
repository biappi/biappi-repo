//
//  MyStubs.h
//  ReverserBench
//
//  Created by Antonio "Willy" Malara on 25/08/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyClass : NSObject {
	NSString * name;
	NSArray * childs;
}

- (id)initWithName:(NSString *)name andChilds:(NSArray *)someChilds;
- (BOOL)leaf;

@end

@interface MyMethod : NSObject {
	NSString * name;
	NSArray * childs;
}

- (id)initWithName:(NSString *)name;
- (BOOL)leaf;

@end