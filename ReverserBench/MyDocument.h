//
//  MyDocument.h
//  ReverserBench
//
//  Created by Antonio "Willy" Malara on 25/08/07.
//  Copyright __MyCompanyName__ 2007 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "CDClassDump.h"

#import "MyStubs.h"

@interface MyDocument : NSDocument
{
	CDClassDump * classdump;
	CDMachOFile * macho;

	NSMutableArray * myClasses;
	NSMutableArray * segmentCommands;
 	NSMutableArray * dylibCommands;
	NSMutableArray * symbols;
	NSMutableArray * indirectSymbols;

	NSMutableDictionary * virtualMemory;

	IBOutlet NSArrayController * classesController;
	IBOutlet NSArrayController * instanceMethodsController;
	IBOutlet NSArrayController * classMethodsController;
	IBOutlet NSTextView * disasmTextView;
}

@end

