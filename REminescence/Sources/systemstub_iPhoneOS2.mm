/*
 *  systemstub_iPhoneOS.cpp
 *  REminescence
 *
 *  Created by Antonio "Willy" Malara on 07/01/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "systemstub_iPhoneOS2.h"
#include <mach/mach_time.h>

#define NO_IMP() printf("Not Implemented: %s\n", __PRETTY_FUNCTION__)

#pragma mark Housekeeping

SystemStub *SystemStub_iPhoneOS_create()
{
	return new SystemStub_iPhoneOS();
}

void SystemStub_iPhoneOS::init(const char *title, uint16 w, uint16 h)
{
	size_t bitmap_size;
	
	screenW = w;
	screenH = h;
	
	bitmap_size = screenW * screenH * sizeof(uint32);
	
	printf ("-> bitmap size: %d\n", bitmap_size);
	
	bitmap = (uint32 *) malloc(bitmap_size);

	memset(&_pi,    0, sizeof(_pi));
	memset(bitmap,  0, bitmap_size);
	memset(palette, 0, sizeof(palette));
	
	CGDataProviderRef dataProvider  = CGDataProviderCreateWithData (nil, bitmap, bitmap_size, nil);
	CGColorSpaceRef   colorSpace    = CGColorSpaceCreateDeviceRGB  ();
	
	cgImage = CGImageCreate(screenW,
							screenH,
							8,
							32,
							screenW * 4,
							colorSpace,
							kCGImageAlphaNoneSkipLast,
							dataProvider,
							nil,
							NO,
							kCGRenderingIntentDefault);

	CGColorSpaceRelease   (colorSpace);
	CGDataProviderRelease (dataProvider);

	UIWindow * window = [(REminescenceAppDelegate*)[[UIApplication sharedApplication] delegate] window];
	mainView = [[GameView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
	[mainView setImage:cgImage];
	[window addSubview:mainView];	
}

void SystemStub_iPhoneOS::destroy()
{
}

#pragma mark Palette Handling

void SystemStub_iPhoneOS::setPalette(const uint8 * pal, uint16 n)
{
	memcpy(palette, pal, n * 3);
}

void SystemStub_iPhoneOS::setPaletteEntry(uint8 i, const Color *c)
{
	palette[i] = *c;
}

void SystemStub_iPhoneOS::getPaletteEntry(uint8 i, Color *c)
{
	*c = palette[i];
}

void SystemStub_iPhoneOS::setOverscanColor(uint8 i)
{
	NO_IMP();
}

#pragma mark Drawing

#define PALETTE_COLOR_TO_xRGB(c) ((c.r << 16) | (c.g << 8) | (c.b))

void SystemStub_iPhoneOS::copyRect(int16 x, int16 y, uint16 w, uint16 h, const uint8 * buf, uint32 pitch)
{
	uint32 * p = bitmap;
	
	p   += y * screenW + x;
	buf += y * pitch   + x;
	
	while (h--)
	{
		for (int i = 0; i < w; i++)
			p[i] = PALETTE_COLOR_TO_xRGB(palette[buf[i]]);
		
		p   += screenW;
		buf += pitch;
	}
}

void SystemStub_iPhoneOS::updateScreen(uint8 shakeOffset)
{
	[mainView setNeedsDisplay];
}

#pragma mark Events

void SystemStub_iPhoneOS::processEvents()
{
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
}

#pragma mark Timing

void SystemStub_iPhoneOS::sleep(uint32 duration)
{
	usleep(duration * 1000);
}

uint32 SystemStub_iPhoneOS::getTimeStamp()
{
	static NSDate * start = nil;
	
	if (start == nil)
		start = [NSDate new];
	
	NSDate* now = [NSDate new];
	uint32 ticks = [now timeIntervalSinceDate:start] * 1000;
	[now release];
	return ticks;
}

#pragma mark Audio

void SystemStub_iPhoneOS::startAudio(AudioCallback callback, void *param)
{
	NO_IMP();
}

void SystemStub_iPhoneOS::stopAudio()
{
	NO_IMP();
}

uint32 SystemStub_iPhoneOS::getOutputSampleRate()
{
	return 44100;
}

#pragma mark Mutex

void * SystemStub_iPhoneOS::createMutex()
{
	return [NSLock new];
}

void SystemStub_iPhoneOS::destroyMutex(void *mutex)
{
	[(NSLock*)mutex release];
}

void SystemStub_iPhoneOS::lockMutex(void *mutex)
{
	[(NSLock*)mutex lock];
}

void SystemStub_iPhoneOS::unlockMutex(void *mutex)
{
	[(NSLock*)mutex unlock];
}
