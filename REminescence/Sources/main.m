//
//  main.m
//  REminescence
//
//  Created by Antonio "Willy" Malara on 06/01/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
	NSInteger           returnValue;
    NSAutoreleasePool * pool;
	
	pool        = [[NSAutoreleasePool alloc] init];
    returnValue = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
	
    return returnValue;
}
