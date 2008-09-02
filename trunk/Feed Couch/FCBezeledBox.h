//
//  FCEntryTitle.h
//  FeedCouch
//
//  Created by Antonio Malara on 20/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CoreAnimation.h>
#import <PubSub/PubSub.h>

typedef enum {
	kUnselectedState,
	kSelectedState,
	kTopBarState
} bezeledBoxStates;

@interface FCBezeledBox : CALayer
{
	CATextLayer * title;
}

+ (NSArray *)selectedFilters;
+ (NSArray *)unselectedFilters;
+ (CABasicAnimation *)selectedAnimation;

- (id)initWithAttributedString:(NSAttributedString *)aString;
- (void)setString:(NSAttributedString *)newString;
- (void)buildGradient;
- (void)setState:(bezeledBoxStates)newState;

@end
