//
//  REminescenceButtonView.m
//  REminescence
//
//  Created by ∞ on 07/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "REminescenceButtonView.h"
#import "REminescenceAppDelegate.h"

@interface REminescenceButtonView ()

- (void) _updateDelegateKeyWithValue:(BOOL) val;

@end


@implementation REminescenceButtonView

- (void) _updateDelegateKeyWithValue:(BOOL) val {
	REminescenceAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
	[delegate setValue:[NSNumber numberWithBool:val] forKey:self.delegateKey];
	L0Log(@"Updated button value = %d for key = %@", val, self.delegateKey);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self _updateDelegateKeyWithValue:YES];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self _updateDelegateKeyWithValue:NO];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self _updateDelegateKeyWithValue:NO];
}

- (void)dealloc {
	[delegateKey release];
    [super dealloc];
}

@synthesize delegateKey;

@end
