/*
 *  systemstub_iPhoneOS.h
 *  REminescence
 *
 *  Created by Antonio "Willy" Malara on 07/01/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "systemstub.h"

#import <UIKit/UIKit.h>

#import "GameView.h"
#import "REminescenceAppDelegate.h"

struct SystemStub_iPhoneOS : SystemStub
{
	CGImageRef   cgImage;
	GameView   * mainView;
	uint16       screenW;
	uint16       screenH;

	Color        palette[256];
	uint32     * bitmap;
	
	/* --- */
	
	virtual          ~SystemStub_iPhoneOS() {}

	virtual void     init(const char *title, uint16 w, uint16 h);
	virtual void     destroy();
	
	virtual void     setPalette(const uint8 *pal, uint16 n);
	virtual void     setPaletteEntry(uint8 i, const Color *c);
	virtual void     getPaletteEntry(uint8 i, Color *c);
	virtual void     setOverscanColor(uint8 i);
	virtual void     copyRect(int16 x, int16 y, uint16 w, uint16 h, const uint8 *buf, uint32 pitch);
	virtual void     updateScreen(uint8 shakeOffset);
	
	virtual void     processEvents();
	virtual void     sleep(uint32 duration);
	virtual uint32   getTimeStamp();
	
	virtual void     startAudio(AudioCallback callback, void *param);
	virtual void     stopAudio();
	virtual uint32   getOutputSampleRate();
	
	virtual void   * createMutex();
	virtual void     destroyMutex(void *mutex);
	virtual void     lockMutex(void *mutex);
	virtual void     unlockMutex(void *mutex);
};
