 /*
 *	File:		txVtt.cpp
 *	
 *	Version:	1.0
 * 
 *	Created:	9/11/06
 *	
 *	Copyright:  Copyright © 2006 __MyCompanyName__, All Rights Reserved
 * 
 *	Disclaimer:	IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc. ("Apple") in 
 *				consideration of your agreement to the following terms, and your use, installation, modification 
 *				or redistribution of this Apple software constitutes acceptance of these terms.  If you do 
 *				not agree with these terms, please do not use, install, modify or redistribute this Apple 
 *				software.
 *
 *				In consideration of your agreement to abide by the following terms, and subject to these terms, 
 *				Apple grants you a personal, non-exclusive license, under Apple's copyrights in this 
 *				original Apple software (the "Apple Software"), to use, reproduce, modify and redistribute the 
 *				Apple Software, with or without modifications, in source and/or binary forms; provided that if you 
 *				redistribute the Apple Software in its entirety and without modifications, you must retain this 
 *				notice and the following text and disclaimers in all such redistributions of the Apple Software. 
 *				Neither the name, trademarks, service marks or logos of Apple Computer, Inc. may be used to 
 *				endorse or promote products derived from the Apple Software without specific prior written 
 *				permission from Apple.  Except as expressly stated in this notice, no other rights or 
 *				licenses, express or implied, are granted by Apple herein, including but not limited to any 
 *				patent rights that may be infringed by your derivative works or by other works in which the 
 *				Apple Software may be incorporated.
 *
 *				The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO WARRANTIES, EXPRESS OR 
 *				IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY 
 *				AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE 
 *				OR IN COMBINATION WITH YOUR PRODUCTS.
 *
 *				IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL 
 *				DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 *				OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, 
 *				REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER 
 *				UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN 
 *				IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */
/*=============================================================================
	txVtt.cpp
	
 =============================================================================*/

#include "txVtt.h"

COMPONENT_ENTRY(txVtt)

CFStringRef kFilenameString = CFSTR("BIAP-Filename");

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	txVtt::txVtt
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
txVtt::txVtt(ComponentInstance inComponentInstance)
	: AUBase(inComponentInstance, 0, 1),
	  vtt(new vtt_class),
	  filename(NULL),
	  oldScratchValue(0)
{
	CreateElements();	
	Globals()->UseIndexedParameters (kNumberOfParameters);
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	txVtt::Initialize
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ComponentResult txVtt::Initialize()
{
	AUBase::Initialize();	

	vtt->set_output_buffer_size(GetMaxFramesPerSlice());
	vtt->set_sample_rate(GetOutput(0)->GetStreamFormat().mSampleRate);
	
	for (int i = 0; i < kNumberOfParameters; i++)
		SetParameter(i, kAudioUnitScope_Global, 0, kAllParametersInformations[i].defaultValue, 0);
	
	return noErr;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	txVtt::GetParameterInfo
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ComponentResult txVtt::GetParameterInfo(AudioUnitScope inScope, AudioUnitParameterID inParameterID, AudioUnitParameterInfo &outParameterInfo)
{
	if (inScope != kAudioUnitScope_Global)
		return kAudioUnitErr_InvalidScope;

	if (inParameterID >= kNumberOfParameters)
		return kAudioUnitErr_InvalidParameter;

	outParameterInfo = kAllParametersInformations[inParameterID];

	CFStringRef name = CFStringCreateWithCString(kCFAllocatorDefault, kAllParametersInformations[inParameterID].name, kCFStringEncodingUTF8);
	outParameterInfo.cfNameString = name;
	// CFRelease(name); // Thou Shalt Not Release. Good Ole Gdb Says.
	
	return noErr;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	txVtt::StreamFormatWriteable
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bool txVtt::StreamFormatWritable(AudioUnitScope scope, AudioUnitElement element)
{
	return IsInitialized() ? false : true;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	txVtt::GetPropertyInfo
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ComponentResult	txVtt::GetPropertyInfo (	AudioUnitPropertyID				inID,
											AudioUnitScope					inScope,
											AudioUnitElement				inElement,
											UInt32 &						outDataSize,
											Boolean &						outWritable)
{
	if (inScope == kAudioUnitScope_Global)
	{
		switch (inID)
		{
			case kAudioUnitProperty_CocoaUI:
				outWritable = false;
				outDataSize = sizeof (AudioUnitCocoaViewInfo);
				return noErr;
			
			case kFilenameProperty:
				outWritable = true;
				outDataSize = sizeof (CFStringRef);
				return noErr;

			case kMusicDeviceProperty_InstrumentCount:
				outWritable = false;
				outDataSize = sizeof (UInt32);
				return noErr;
		}
	}
	
	return AUBase::GetPropertyInfo (inID, inScope, inElement, outDataSize, outWritable);
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	txVtt::GetProperty
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ComponentResult txVtt::GetProperty (	AudioUnitPropertyID 		inID,
										AudioUnitScope 				inScope,
										AudioUnitElement			inElement,
										void *						outData)
{
	if (inScope == kAudioUnitScope_Global)
	{
		switch (inID)
		{
			case kAudioUnitProperty_CocoaUI:
			{
				// Look for a resource in the main bundle by name and type.
				CFBundleRef bundle = CFBundleGetBundleWithIdentifier(CFSTR("com.la-fuffa.audiounit.txVtt"));
				
				if (bundle == NULL)
					return fnfErr;
                
				CFURLRef bundleURL = CFBundleCopyResourceURL( bundle, 
                    CFSTR("CocoaView"),	// this is the name of the cocoa bundle as specified in the CocoaViewFactory.plist
                    CFSTR("bundle"),    // this is the extension of the cocoa bundle
                    NULL);
                
                if (bundleURL == NULL)
					return fnfErr;
                
				CFStringRef className = CFSTR("txVtt_ViewFactory"); // name of the main class that implements the AUCocoaUIBase protocol
				AudioUnitCocoaViewInfo cocoaInfo = { bundleURL, className };
				*(AudioUnitCocoaViewInfo *)outData = cocoaInfo;
				
				return noErr;
			}
			
			case kMusicDeviceProperty_InstrumentCount:
				*(UInt32 *)outData = 0;
				return noErr;
			
			case kFilenameProperty:
				*(CFStringRef *)outData = filename;
				return noErr;
		}
	}
	
	return AUBase::GetProperty(inID, inScope, inElement, outData);
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	txVtt::SetProperty
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ComponentResult		txVtt::SetProperty(	AudioUnitPropertyID 			inID,
										AudioUnitScope 					inScope,
										AudioUnitElement 				inElement,
										const void *					inData,
										UInt32 							inDataSize)
{
	if (inScope == kAudioUnitScope_Global)
	{
		switch (inID)
		{
			case kFilenameProperty:
				return LoadFile((CFStringRef) inData);
		}
	}
	
	return AUBase::SetProperty(inID, inScope, inElement, inData, inDataSize);
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	txVtt::SaveState
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ComponentResult txVtt::SaveState(CFPropertyListRef * outData)
{
	ComponentResult result = AUBase::SaveState(outData);
	
	if (result != noErr)
		return result;
	
	if (filename != NULL)
		CFDictionarySetValue((CFMutableDictionaryRef)*outData, kFilenameString, filename);

	return noErr;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	txVtt::RestoreState
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ComponentResult txVtt::RestoreState(CFPropertyListRef plist)
{
	ComponentResult result = AUBase::RestoreState(plist);
	
	if (result != noErr)
		return result;

	CFStringRef newFile;
	if (CFDictionaryGetValueIfPresent((CFDictionaryRef)plist, kFilenameString, (const void **)&newFile))
		LoadFile(newFile);
	
	return noErr;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	txVtt::LoadFile
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ComponentResult txVtt::LoadFile(CFStringRef newFile)
{
	ComponentResult res = noErr;
	CFIndex len;
	
	if (filename)
		CFRelease(filename);

	filename = newFile;
	CFRetain(filename);
	
	len = CFStringGetMaximumSizeOfFileSystemRepresentation(filename);
	char * file = (char *) malloc(len);
	
	CFStringGetCString(filename, file, len, kCFStringEncodingUTF8);
	
	if (vtt->load_file(file) != TX_AUDIO_SUCCESS)
		res = kAudioUnitErr_InvalidPropertyValue;
	
	free (file);
	
	return res;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	txVtt::Render
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ComponentResult	txVtt::Render(AudioUnitRenderActionFlags & ioActionFlags, const AudioTimeStamp & inTimeStamp, UInt32 inNumberFrames)
{
	float temp;
	
	// Volume
	{
		GetParameter(kVolume, kAudioUnitScope_Global, 0, temp);
		vtt->set_volume(temp);
	}
	
	// Pan
	{
		GetParameter(kPan, kAudioUnitScope_Global, 0, temp);
		vtt->set_pan(temp);
	}
	
	// Trigger!
	{
		GetParameter(kTrigger, kAudioUnitScope_Global, 0, temp);
		SetParameter(kTrigger, kAudioUnitScope_Global, 0, 0, 0);

		if (temp == true)
			vtt->trigger();
	}

	// Loop
	{
		GetParameter(kLoop, kAudioUnitScope_Global, 0, temp);
		vtt->set_loop(temp);
	}

	// Pitch
	{
		GetParameter(kPitch, kAudioUnitScope_Global, 0, temp);
		vtt->set_pitch(temp);
	}

	// Speed... Boh!!
	{
		GetParameter(kPixelScratch, kAudioUnitScope_Global, 0, temp);		
		SetParameter(kPixelScratch, kAudioUnitScope_Global, 0, 0, 0);

		temp *= 0.05 * vtt->audiofile_pitch_correction; // constant from tX_mouse.c

		if (vtt->do_scratch)
			vtt->speed = temp;

		vtt->sense_cycles = SENSE_CYCLES;
	}
		
	// DoScratch
	{
		GetParameter(kDoScratch, kAudioUnitScope_Global, 0, temp);
		if (oldScratchValue != temp)
			vtt->set_scratch(temp);
		oldScratchValue = temp;
	}

	GetOutput(0)->PrepareBuffer(inNumberFrames);
	AudioBufferList& bufferList = GetOutput(0)->GetBufferList();
	AUBufferList::ZeroBuffer(bufferList);
	
	if (vtt->is_playing)
	{
		vtt->render();

		Float32 * out1 = (Float32 *) bufferList.mBuffers[0].mData;
		Float32 * out2 = (Float32 *) bufferList.mBuffers[1].mData;
	
		for (int sample = 0; sample < vtt->samples_in_outputbuffer; sample++)
		{
			out1[sample] = vtt->get_output_buffer()[sample];
			out2[sample] = vtt->get_output_buffer2()[sample];
		}
	}

	return noErr;
}
