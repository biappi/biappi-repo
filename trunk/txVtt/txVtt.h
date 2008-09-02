/*
 *  txVtt.h
 *  txVtt
 *
 *  Created by Mehul Trivedi on 9/12/06.
 *  Copyright 2006 __MyCompanyName__. All rights reserved.
 *
 */

#include "txVttVersion.h"
#include "AUBase.h"
#include "txVtt_Parameters.h"
#include "tX_vtt.h"

class txVtt : public AUBase
{
	public:
		txVtt(ComponentInstance inComponentInstance);
				
		virtual ComponentResult	Initialize();
		virtual ComponentResult	Version() { return ktxVttVersion; }
	
		virtual ComponentResult	GetParameterInfo(AudioUnitScope inScope, AudioUnitParameterID inParameterID, AudioUnitParameterInfo &outParameterInfo);
		
		virtual ComponentResult GetPropertyInfo (AudioUnitPropertyID inID, AudioUnitScope inScope, AudioUnitElement inElement, UInt32 & outDataSize, Boolean & outWritable);
		virtual ComponentResult	GetProperty     (AudioUnitPropertyID inID, AudioUnitScope inScope, AudioUnitElement inElement, void * outData);
		virtual ComponentResult SetProperty     (AudioUnitPropertyID inID, AudioUnitScope inScope, AudioUnitElement inElement, const void * inData, UInt32 inDataSize);

		virtual ComponentResult SaveState(CFPropertyListRef * outData);
		virtual ComponentResult RestoreState(CFPropertyListRef plist);

		ComponentResult LoadFile (CFStringRef newFile);

		virtual bool StreamFormatWritable(AudioUnitScope scope, AudioUnitElement element);

		virtual ComponentResult Render(AudioUnitRenderActionFlags & ioActionFlags, const AudioTimeStamp & inTimeStamp, UInt32 inNumberFrames);

	private:
		vtt_class * vtt;
		CFStringRef filename;
		float oldScratchValue;
};
