//
//  XMLRPCParser.h
//  Untitled
//
//  Created by Antonio "Willy" Malara on 17/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMLRPCParser : NSObject
{
	NSMutableArray * frameStack;
	NSMutableString * data;
}

+ (id)decodeData:(NSData *)someData;
- (id)parseData:(NSData *)someData;

@end
