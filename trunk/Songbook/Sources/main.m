//
//  main.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 21/12/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
	NSInteger           returnValue;
    NSAutoreleasePool * pool;
	
	pool        = [[NSAutoreleasePool alloc] init];
    returnValue = UIApplicationMain(argc, argv, nil, @"SongbookAppDelegate");
    [pool release];
	
    return returnValue;
}
