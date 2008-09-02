//
//  FCController.h
//  Feed Couch
//
//  Created by Antonio Malara on 01/07/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FCController : NSResponder {
    IBOutlet id view;
}

- (void)awakeFromNib;
- (void)goBack:(id)sender;

@end
