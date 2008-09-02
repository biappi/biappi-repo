//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 1997-1998, 2000-2001, 2004-2005  Steve Nygard

#import "CDLoadCommand.h"
#import <Cocoa/Cocoa.h>

@interface CDDynamicSymbolTable : CDLoadCommand
{
    struct dysymtab_command dysymtab;
	NSMutableArray * indirectSymbols;
}

- (id)initWithPointer:(const void *)ptr machOFile:(CDMachOFile *)aMachOFile;
- (void)_process;
- (NSArray *)indirectSymbols;

@end
