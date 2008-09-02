//
//  MyDisass.m
//  ReverserBench
//
//  Created by Antonio "Willy" Malara on 28/08/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MyDisass.h"
#import "libdis.h"
#import "CDMachOFile.h"
#import "ia32_insn.h"
#import "CDSymbol.h"

@implementation CDOCMethod (MyDisass)

- (NSString *)disassWithMachO:(CDMachOFile *)macho withMemory:(NSMutableDictionary *)virtualMemory;
{
	int pos = 0;
	size_t size;
	x86_insn_t currentInstruction;
	char line[80];

	NSMutableString * dis = [NSMutableString string];
	unsigned long segmentOffset = [[macho segmentContainingAddress:imp] vmaddr];
	void * buffer = (void *)[macho pointerFromVMAddr:imp];

	x86_init(opt_none, nil, nil);

	BOOL should_break = NO;

	
	while (!should_break)
	{
		size = x86_disasm(buffer, MAX_INSTRUCTION_SIZE, imp + pos, 0, &currentInstruction);
		x86_format_insn(&currentInstruction, line, 80, att_syntax);
		
		// If the instruction is push %ebp that means we've reached the
		// prologue of another function
		
		if (currentInstruction.type == insn_push && pos != 0)
			if (currentInstruction.operands->op.data.reg.id == 6) // ebp
				should_break = YES;
		
		NSString * nsline = [NSString stringWithFormat:@"0x%08X\t%s", imp + pos, line];
				
		if (currentInstruction.type == insn_jmp || currentInstruction.type == insn_call)
		{
			unsigned long ad = currentInstruction.operands->op.data.sdword + pos + imp + currentInstruction.size;
			NSNumber * address = [NSNumber numberWithUnsignedLong:ad];
			CDSymbol * symbol = [virtualMemory objectForKey:address];
			
			if (symbol)
				nsline = [nsline stringByAppendingFormat:@"\t%@", [symbol name]];
		}
		
		if (currentInstruction.type == insn_mov)
		{
			x86_op_t * op;
						
			op = x86_operand_1st(&currentInstruction);
			if (op->type == op_offset)
			{
				id pippo = [virtualMemory objectForKey:[NSNumber numberWithUnsignedLong:op->data.sdword + segmentOffset]];
				if (pippo)
				{
					nsline = [nsline stringByAppendingString:@"\t"];
					nsline = [nsline stringByAppendingString:[pippo description]];
				}
			}

			op = x86_operand_2nd(&currentInstruction);			
			if (op->type == op_offset)
			{
				id pippo = [virtualMemory objectForKey:[NSNumber numberWithUnsignedLong:op->data.sdword]];
				if (pippo)
				{
					nsline = [nsline stringByAppendingString:@"\t"];
					nsline = [nsline stringByAppendingString:[pippo description]];
				} else {
					unsigned long temp = *(unsigned long *)[macho pointerFromVMAddr:op->data.sdword];
					pippo = [virtualMemory objectForKey:[NSNumber numberWithUnsignedLong:temp]];
					if (pippo)
					{
						nsline = [nsline stringByAppendingString:@"\t"];
						nsline = [nsline stringByAppendingString:[pippo description]];
					} else {
						nsline = [nsline stringByAppendingString:@"\t"];
						nsline = [nsline stringByAppendingString:[macho stringFromVMAddr:temp]];
					}
				}
			}
		}
		
		nsline = [nsline stringByAppendingString:@"\n"];
		[dis appendString:nsline];

		buffer += size;
		pos += size;
	}
	
	return dis;
}

@end