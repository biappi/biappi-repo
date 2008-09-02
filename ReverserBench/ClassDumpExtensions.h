//
//  ClassDumpExtensions.h
//  ReverserBench
//
//  Created by Antonio "Willy" Malara on 25/08/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CDClassDump.h"
#import "CDOCMethod.h"
#import "CDObjCSegmentProcessor.h"
#import "CDSection.h"
#import "CDSymbol.h"
#import "CDSymbolTable.h"
#import "CDDynamicSymbolTable.h"

@interface CDClassDump (ClassDumpExtensions)

- (NSMutableArray *)objcSegmentProcessors;
- (NSMutableDictionary *)machOFilesByID;

@end

@interface CDObjCSegmentProcessor (ClassDumpExtensions)

- (NSMutableArray *)modules;
- (NSMutableDictionary *)protocols;

@end

@interface CDOCMethod (ClassDumpExtensions)

- (NSString *)impString;

@end

@interface CDSection (ClassDumpExtensions)

- (NSArray *)sections;
- (NSString *)name;
- (unsigned long)vmaddr;
- (unsigned long)cmdsize;
- (unsigned long)fileoff;
- (NSString *)flagDescription;
- (unsigned long)flags;
- (unsigned long)reserved1;
- (unsigned long)reserved2;

- (unsigned long)flags;
- (unsigned long)type;
- (unsigned long)attributes;

@end

@interface CDSymbol (ClassDumpExtensions)

- (NSString *)typeString;
- (NSString *)descString;
- (NSString *)sectionString;

@end

@interface CDSymbolTable (ClassDumpExtensions)

- (NSMutableArray *)symbols;

@end

