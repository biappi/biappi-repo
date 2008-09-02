//
//  MyDocument.m
//  ReverserBench
//
//  Created by Antonio "Willy" Malara on 25/08/07.
//  Copyright __MyCompanyName__ 2007 . All rights reserved.
//

#import "MyDocument.h"
#import "ClassDumpExtensions.h"
#import "MyStubs.h"
#import "CDObjCSegmentProcessor.h"
#import "CDOCSymtab.h"
#import "CDOCClass.h"
#import "CDOCMethod.h"
#import "CDOCModule.h"
#import "CDSegmentCommand.h"
#import "CDMachOFile.h"
#import "MyDisass.h"

@interface HexValueTransformer : NSValueTransformer{}
@end

@implementation MyDocument

+ (void)initialize
{
	HexValueTransformer * hx = [[[HexValueTransformer alloc] init] autorelease];
	[NSValueTransformer setValueTransformer:hx forName:@"HexValue"];
}

- (id)init
{
	if (!(self = [super init]))
		return nil;

	classdump = [[CDClassDump alloc] init];
	virtualMemory = [[NSMutableDictionary alloc] init];
	return self;
}

- (void) dealloc
{
	[classdump release];
	[myClasses release];
	[segmentCommands release];
	[dylibCommands release];
	[symbols release];
	[virtualMemory release];
	
	[super dealloc];
}

- (NSString *)windowNibName
{
	return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
	[super windowControllerDidLoadNib:aController];
	[disasmTextView setFont:[NSFont fontWithName:@"Monaco" size:10]];
}

- (void)staminchia
{
	NSEnumerator * lcEn = [[macho loadCommands] objectEnumerator];
	CDLoadCommand * loadCommand;
	
	lcEn = [[macho loadCommands] objectEnumerator];
	while (loadCommand = [lcEn nextObject])
	{
		if ([loadCommand isKindOfClass:[CDSegmentCommand class]])
		{
			NSEnumerator * sctEn = [[(CDSegmentCommand *)loadCommand sections] objectEnumerator];
			CDSection * section;
			
			while (section = [sctEn nextObject])
			{
				// boh! all this names 're taken from otool's sources
				unsigned long stride; 
				unsigned long count;
				unsigned long n;
				
				switch ([section type])
				{
					case S_SYMBOL_STUBS:
						if ((stride = [section reserved2]) == 0)
							continue; // "can't print indirect symbol, size o stubs is 0"
						break;
					
					case S_LAZY_SYMBOL_POINTERS:
					case S_NON_LAZY_SYMBOL_POINTERS:
						stride = sizeof(unsigned long);
						break;
					
					default:
						continue;
				}

				count = [section size] / stride;
				n = [section reserved1];
				int j;
				for (j = 0; j < count && n + j < [indirectSymbols count]; j++)
				{
					unsigned long symbolAddress = (unsigned long)([section addr] + j * stride);
					unsigned long indirectSymbol = [[indirectSymbols objectAtIndex:(j+n)] unsignedLongValue];

					
					switch (indirectSymbol)
					{
						case INDIRECT_SYMBOL_LOCAL:
							continue;

						case INDIRECT_SYMBOL_LOCAL | INDIRECT_SYMBOL_ABS:
							continue;
					}
					
					[[symbols objectAtIndex:indirectSymbol] setValue:symbolAddress];
					[virtualMemory setObject:[symbols objectAtIndex:indirectSymbol]
						forKey:[NSNumber numberWithUnsignedLong:symbolAddress]]; 
					
					printf("0x%08X %5lu %s\n", symbolAddress, indirectSymbol,
						[[[symbols objectAtIndex:indirectSymbol] name] cString]);
				}
			}
		}
	}
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outError
{
	if ([url isFileURL] == NO)
	{
		// TODO: colcazzo! deve tornare un errore!
		return YES;
	}

	if ([typeName isEqual:@"AppBundles"])
	{
		NSString * path = [[url path] stringByAppendingString:@"/"];
		if ([classdump processFilename:path inVM:virtualMemory] == YES)
		{
			// Load Classes
			{
				NSEnumerator * segmentsIterator;
				CDObjCSegmentProcessor * segment;
				
				myClasses = [[NSMutableArray alloc] init];
				
				segmentsIterator = [[classdump objcSegmentProcessors] objectEnumerator];
				while (segment = [segmentsIterator nextObject])
				{
					NSEnumerator * modulesIterator = [[segment modules] objectEnumerator];
					CDOCModule * module;
					
					while (module = [modulesIterator nextObject])
						[myClasses addObjectsFromArray:[[module symtab] classes]];
				}
			}
			
			// Load binary segments/shits
			{
				NSEnumerator * files = [[classdump machOFilesByID] objectEnumerator];
				CDMachOFile * file;
				while (file = [files nextObject])
				{
					NSArray * lc = [file loadCommands];
					NSEnumerator * loadCommands = [lc objectEnumerator];
					CDLoadCommand * loadCommand;
					macho = file;
					segmentCommands = [[NSMutableArray alloc] init];
					dylibCommands = [[NSMutableArray alloc] init];
					
					while (loadCommand = [loadCommands nextObject])
					{
						if ([loadCommand isKindOfClass:[CDSegmentCommand class]])
							[segmentCommands addObject:loadCommand];
						
						if ([loadCommand isKindOfClass:[CDDylibCommand class]])
							[dylibCommands addObject:loadCommand];
						
						if ([loadCommand isKindOfClass:[CDSymbolTable class]])
							symbols = [[(CDSymbolTable *)loadCommand symbols] retain];
							
						if ([loadCommand isKindOfClass:[CDDynamicSymbolTable class]])
							indirectSymbols = [[(CDDynamicSymbolTable *)loadCommand indirectSymbols] retain];
					}
				}
			}
			
			// Load __IMPORT,__POINTERS if i can do it. \o/ i did it! (at least for cfstrings)
			{
				CDSegmentCommand * importSegment = [macho segmentWithName:@"__IMPORT"];
				CDSection * pointerSection = [importSegment sectionWithName:@"__pointers"];

				CDSegmentCommand * dataSegment = [macho segmentWithName:@"__DATA"];
				CDSection * cfstringSection = [dataSegment sectionWithName:@"__cfstring"];
				CDSection * constSection = [dataSegment sectionWithName:@"__const"];
				
				unsigned long data;
				for (data = [pointerSection vmaddr];
					 data < ([pointerSection vmaddr] + [pointerSection size]);
					 data += sizeof(unsigned long))
				{
					unsigned long pointer = *(unsigned long *) [macho pointerFromVMAddr:data];
					if ([constSection containsAddress:pointer])
					{
						unsigned long pointed = *(unsigned long *)[macho pointerFromVMAddr:pointer];
						if ([cfstringSection containsAddress:pointed])
						{
							unsigned long cstring = *(unsigned long *)[macho pointerFromVMAddr:pointed + 8];
							[virtualMemory setObject:[macho stringFromVMAddr:cstring] forKey:[NSNumber numberWithUnsignedLong:data]];
						}
					} 
				}
			}
			
			[self staminchia];
			printf("%s", [[virtualMemory description] cString]);
		} else
			NSLog(@"no");
		
		return YES;
	}
	
	return YES;
}

- (id)classdump
{
	return classdump;
}

- (id)disass:(id)sender
{
	[disasmTextView setString:[[[instanceMethodsController selection] valueForKey:@"self"] disassWithMachO:macho withMemory:virtualMemory]];
	return nil;
}

@end


@implementation HexValueTransformer
+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
- (id)transformedValue:(id)item {
    return [NSString stringWithFormat:@"0x%08X", [item unsignedIntValue]];
}
@end