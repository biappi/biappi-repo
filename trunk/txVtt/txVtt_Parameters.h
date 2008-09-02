/*
 *  txVtt_Parameters.h
 *  txVtt
 *
 *  Created by Antonio Malara on 08/01/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

enum {
	kVolume = 0,
	kMute,
	kPan,
	
	kTrigger,
	kLoop,
	kPitch,
	
	kPixelScratch,
	kDoScratch,
	kSpeed,
	
	kNumberOfParameters
};


#define aGENERIC kAudioUnitParameterUnit_Generic
#define aBOOLEAN kAudioUnitParameterUnit_Boolean
#define aPAN     kAudioUnitParameterUnit_Pan
#define aGAIN    kAudioUnitParameterUnit_LinearGain
#define aa       0, 0, 0
#define aRW      (kAudioUnitParameterFlag_IsReadable | kAudioUnitParameterFlag_IsWritable | kAudioUnitParameterFlag_HasCFNameString)
#define aRO      (kAudioUnitParameterFlag_IsReadable | kAudioUnitParameterFlag_HasCFNameString)

static const AudioUnitParameterInfo kAllParametersInformations[]= {
	{ "Volume",     aa, aGAIN,     0.00, 2.00, 1.00, aRW },
	{ "Mute",       aa, aBOOLEAN,  0.00, 1.00, 0.00, aRW },
	{ "Pan",        aa, aPAN,     -1.00, 1.00, 0.00, aRW },
	{ "Trigger",    aa, aBOOLEAN,  0.00, 1.00, 0.00, aRW },
	{ "Loop",       aa, aBOOLEAN,  0.00, 1.00, 1.00, aRW },
	{ "Pitch",      aa, aGENERIC, -3.00, 3.00, 1.00, aRW },
	{ "Scratch",    aa, aGENERIC, -1000, 1000, 0.00, aRW },
	{ "Do Scratch", aa, aBOOLEAN,  0.00, 1.00, 0.00, aRW },
	{ "Speed",      aa, aGENERIC,  -100,  100, 0.00, aRO }
};

#undef aGENERIC
#undef aBOOLEAN
#undef aPAN
#undef aGIN
#undef aaa
#undef aRW
#undef aRO


static const AudioUnitPropertyID kFilenameProperty = 65536;
