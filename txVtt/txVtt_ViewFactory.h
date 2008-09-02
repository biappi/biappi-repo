//
//  txVtt_ViewFactory.h
//  txVtt
//
//  Created by Antonio Malara on 08/01/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AudioUnit/AUCocoaUIView.h>
#import "txVtt_MainView.h"

@interface txVtt_ViewFactory : NSObject <AUCocoaUIBase>
{
    IBOutlet txVtt_MainView *uiFreshlyLoadedView;	// This class is the File's Owner of the CocoaView nib
}

- (NSString *) description;	// string description of the view

@end
