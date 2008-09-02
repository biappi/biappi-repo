/*
 * Vanneschi Virtual Machine
 * -------------------------
 *
 */

#include <stdio.h>

#define VM_SIZE 512

// Instruction Format
#define OPCODE(x) ((x & 0xFF000000) >> 24)

#define RG1(x)    ((x & 0x00FC0000) >> 18)
#define RG2(x)    ((x & 0x0003F000) >> 12)
#define RG3(x)    ((x & 0x00000FC0) >>  6)

#define GOTO_OFF(x)   (x & 0x00FFFFFF)

// ASSEMBLER
#define as_ADD(r1,r2,r3)   ((0x00 << 24) | (r1 << 18) | (r2 << 12) | (r3 << 6))
#define as_LOAD(r1,r2,r3)  ((0x01 << 24) | (r1 << 18) | (r2 << 12) | (r3 << 6))
#define as_STORE(r1,r2,r3) ((0x02 << 24) | (r1 << 18) | (r2 << 12) | (r3 << 6))
#define as_GOTO(r1,off)    ((0x03 << 24) | GOTO_OFF(off))
#define as_END              (0x04 << 24)
//

class Processor
{
	private:
		bool endReached;
		unsigned long IC;          // Instruction Counter
		unsigned long IR;          // Instruction Register
		unsigned long RG[64];      // General Registers
		unsigned long MV[VM_SIZE]; // Virtual Memory

	public:
		Processor();
		
		void run();
		
		void van_add   ();
		void van_load  ();
		void van_store ();
		void van_goto  ();
		void van_end   ();
};

typedef void (Processor::*function)();

function implementation[] = {
	&Processor::van_add,
	&Processor::van_load,
	&Processor::van_store,
	&Processor::van_goto,
	&Processor::van_end
};

Processor::Processor()
{
	RG[0] = 0;
	RG[1] = 1;
	RG[2] = 2;
	RG[3] = 5;
	RG[4] = 0;
	
	IC = 0;
	IR = 0;
	
	MV[0] = as_ADD(1,2,3);   // ADD   r1, r2, r3
	MV[1] = as_STORE(4,0,1); // STORE r4, r0, r1
	MV[2] = as_END;          // END
}

void Processor::run()
{
	function decodedFunction;

	while (endReached == false)
	{
		// Fetch
		IR = MV[RG[IC]];
	
		// Decode
		decodedFunction = implementation[OPCODE(IR)];

		// Execute
		(this->*decodedFunction)();
	}
}

void Processor::van_add()
{
	RG[RG3(IR)] = RG[RG1(IR)] + RG[RG2(IR)];
	printf ("IC = 0x%08x - ADD R%d, R%d, R%d\n", IC, RG1(IR), RG2(IR), RG3(IR));
	IC++;
}

void Processor::van_load()
{
	RG[RG3(IR)] = MV[RG1(IR) + RG2(IR)];
	printf ("IC = 0x%08x - LOAD R%d, R%d, R%d\n", IC, RG1(IR), RG2(IR), RG3(IR));
	IC++;
}

void Processor::van_store()
{
	MV[RG1(IR) + RG2(IR)] = RG3(IR);
	printf ("IC = 0x%08x - STORE R%d, R%d, R%d\n", IC, RG1(IR), RG2(IR), RG3(IR));
	IC++;
}

void Processor::van_goto()
{
	printf ("IC = 0x%08x - GOTO %i\n", IC, GOTO_OFF(IR));
	IC += GOTO_OFF(IR);
}

void Processor::van_end()
{
	printf ("IC = 0x%08x - END\n", IC);
	endReached = true;
}

int main()
{
	Processor p;
	
	p.run();
	
	return 0;
}
