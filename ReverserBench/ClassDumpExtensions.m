//
//  ClassDumpExtensions.m
//  ReverserBench
//
//  Created by Antonio "Willy" Malara on 25/08/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "ClassDumpExtensions.h"
#import <mach-o/nlist.h>
#import <mach-o/stab.h>

@implementation CDClassDump (ClassDumpExtensions)

- (NSMutableArray *)objcSegmentProcessors
{
	return objCSegmentProcessors;
}

- (NSMutableDictionary *) machOFilesByID
{
	return machOFilesByID;
}

@end

@implementation CDObjCSegmentProcessor (ClassDumpExtensions)

- (NSMutableArray *)modules
{
	return modules;
}

- (NSMutableDictionary *)protocols
{
	return protocolsByName;
}

@end

@implementation CDOCMethod (ClassDumpExtensions)

- (NSString *)impString
{
	return [NSString stringWithFormat:@"0x%08X", imp];
}

@end

@implementation CDSection (ClassDumpExtensions)

- (NSArray *)sections
{
	return nil;
}

- (NSString *)name
{
	return sectionName;
}

- (unsigned long)vmaddr
{
	return [self addr];
}

- (unsigned long)cmdsize
{
	return [self size];
}

- (unsigned long)fileoff
{
	return [self offset];
}

- (unsigned long)flags
{
	return section.flags;
}

- (unsigned long)type
{
	return section.flags & SECTION_TYPE;
}

- (unsigned long)attributes
{
	return section.flags & SECTION_ATTRIBUTES;
}

- (NSString *)flagDescription
{
	NSMutableArray * flags;
	NSString * typeString;
	flags = [NSMutableArray array];
	
	switch ([self type])
	{
		case S_REGULAR: typeString = @"S_REGULAR"; break;
		case S_ZEROFILL: typeString = @"S_ZEROFILL"; break;
		case S_CSTRING_LITERALS: typeString = @"S_CSTRING_LITERALS"; break;
		case S_4BYTE_LITERALS: typeString = @"S_4BYTE_LITERALS"; break;
		case S_8BYTE_LITERALS: typeString = @"S_8BYTE_LITERALS"; break;
		case S_LITERAL_POINTERS: typeString = @"S_LITERAL_POINTERS"; break;
		case S_NON_LAZY_SYMBOL_POINTERS: typeString = @"S_NON_LAZY_SYMBOL_POINTERS"; break;
		case S_LAZY_SYMBOL_POINTERS: typeString = @"S_LAZY_SYMBOL_POINTERS"; break;
		case S_SYMBOL_STUBS: typeString = @"S_SYMBOL_STUBS"; break;
		case S_MOD_INIT_FUNC_POINTERS: typeString = @"S_MOD_INIT_FUNC_POINTERS"; break;
		case S_MOD_TERM_FUNC_POINTERS: typeString = @"S_MOD_TERM_FUNC_POINTERS"; break;
		case S_COALESCED: typeString = @"S_COALESCED"; break;
		case S_GB_ZEROFILL: typeString = @"S_GB_ZEROFILL"; break;
		case S_INTERPOSING: typeString = @"S_INTERPOSING"; break;
		case S_16BYTE_LITERALS: typeString = @"S_16BYTE_LITERALS"; break;
	}

	unsigned long type = [self attributes];
	
	if (type & S_ATTR_PURE_INSTRUCTIONS) [flags addObject:@"S_ATTR_PURE_INSTRUCTIONS"];
	if (type & S_ATTR_NO_TOC) [flags addObject:@"S_ATTR_NO_TOC"];
	if (type & S_ATTR_STRIP_STATIC_SYMS) [flags addObject:@"S_ATTR_STRIP_STATIC_SYMS"];
	if (type & S_ATTR_NO_DEAD_STRIP) [flags addObject:@"S_ATTR_NO_DEAD_STRIP"];
	if (type & S_ATTR_LIVE_SUPPORT) [flags addObject:@"S_ATTR_LIVE_SUPPORT"];
	if (type & S_ATTR_SELF_MODIFYING_CODE) [flags addObject:@"S_ATTR_SELF_MODIFYING_CODE"];
	if (type & S_ATTR_DEBUG) [flags addObject:@"S_ATTR_DEBUG"];
	if (type & S_ATTR_SOME_INSTRUCTIONS) [flags addObject:@"S_ATTR_SOME_INSTRUCTIONS"];
	if (type & S_ATTR_EXT_RELOC) [flags addObject:@"S_ATTR_EXT_RELOC"];
	if (type & S_ATTR_LOC_RELOC) [flags addObject:@"S_ATTR_LOC_RELOC"];
	
	return [NSString stringWithFormat:@"(%@) %@", typeString, [flags componentsJoinedByString:@" "]];
}

- (unsigned long)reserved1
{
	return section.reserved1;
}

- (unsigned long)reserved2
{
	return section.reserved2;
}

@end

@implementation CDSymbol (ClassDumpExtensions)

- (NSString *)typeString
{
	char type = [self type];
	NSMutableArray * flags;
	flags = [NSMutableArray array];
	
	if (type & N_STAB)
		[flags addObject:@"DEBUG"];
	if (type & N_PEXT)
		[flags addObject:@"PRIVATE_EXT"];
	if (type & N_EXT)
		[flags addObject:@"EXTERNAL"];
	
	switch (type & N_TYPE)
	{
		case N_UNDF:
			[flags addObject:@"UNDEFINED"];
			break;
			
		case N_ABS:
			[flags addObject:@"ABSOLUTE"];
			break;
			
		case N_SECT:
			[flags addObject:@"SECTION"];
			break;
			
		case N_PBUD:
			[flags addObject:@"PREBOUND"];
			break;

		case N_INDR:
			[flags addObject:@"INDIRECT"];
			break;
	}
	
	switch ([self desc] & REFERENCE_TYPE)
	{
		case REFERENCE_FLAG_UNDEFINED_NON_LAZY: [flags addObject:@"NON_LAZY"]; break;
		case REFERENCE_FLAG_UNDEFINED_LAZY: [flags addObject:@"LAZY"]; break;
		case REFERENCE_FLAG_DEFINED: [flags addObject:@"DEFINED"]; break;
		case REFERENCE_FLAG_PRIVATE_DEFINED: [flags addObject:@"PRIVATE_DEFINED"]; break;
		case REFERENCE_FLAG_PRIVATE_UNDEFINED_NON_LAZY: [flags addObject:@"PRIVATE_UNDEFINED_NON_LAZY"]; break;
		case REFERENCE_FLAG_PRIVATE_UNDEFINED_LAZY: [flags addObject:@"PRIVATE_UNDEFINED_LAZY"]; break;
	}
		
	return [flags componentsJoinedByString:@" "];
}

- (NSString *)descString
{
	switch ([self desc])
	{
		case N_GSYM: return @"Global";
		case N_FNAME: return @"Procedure name";
		case N_FUN: return @"Procedure name";
		case N_STSYM: return @"Static";
		case N_LCSYM: return @".lcomm";
		case N_BNSYM: return @"Begin nsect";
		case N_OPT: return @"GCC source";
		case N_RSYM: return @"Register";
		case N_SLINE: return @"Source line";
		case N_ENSYM: return @"End nsect";
		case N_SSYM: return @"Structure";
		case N_SO: return @"Source file";
		case N_OSO: return @"Object file";
		case N_LSYM: return @"Local";
		case N_BINCL: return @"Include file begin";
		case N_SOL: return @"Included file name";
		case N_PARAMS: return @"Compiler params";
		case N_VERSION: return @"Compiler vers";
		case N_OLEVEL: return @"Compiler optimization";
		case N_PSYM: return @"Paramter name";
		case N_EINCL: return @"Include file end";
		case N_ENTRY: return @"Alternate entry";
		case N_LBRAC: return @"Left bracket";
		case N_EXCL: return @"Deleted include file";
		case N_RBRAC: return @"Right bracket";
		case N_BCOMM: return @"Begin common";
		case N_ECOMM: return @"End common";
		case N_ECOML: return @"End common (local)";
		case N_LENG: return @"Second stab entry"; 
	}
	return @"";
}

- (NSString *)sectionString
{
	if ([self section] == 0)
		return @"NO SECT";
	return [NSString stringWithFormat:@"%d", [self section]];
}

@end

@implementation CDSymbolTable (ClassDumpExtensions)

- (NSMutableArray *)symbols
{
	return symbols;
}

@end