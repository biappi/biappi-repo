//
//  MyDisass.h
//  ReverserBench
//
//  Created by Antonio "Willy" Malara on 28/08/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CDOCMethod.h"
#import "CDMachOFile.h"

@interface CDOCMethod (MyDisass)

- (NSString *)disassWithMachO:(CDMachOFile *)macho withMemory:(NSMutableDictionary *)virtualMemory;

@end
