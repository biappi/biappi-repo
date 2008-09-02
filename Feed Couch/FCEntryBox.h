//
//  FCEntryBox.h
//  Feed Couch
//
//  Created by Antonio Malara on 01/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <PubSub/PubSub.h>

#import "FCBezeledBox.h"

@interface FCEntryBox : CALayer {
	PSEntry * entry;
	FCBezeledBox * box;
	CATextLayer * text;
	CATextLayer * info;
	int scroll;
	BOOL inBrowser;
}

@property(retain, readwrite) PSEntry * entry;

- (id)initWithEntry:(PSEntry *) entry;
- (void)openUrl;

@end
