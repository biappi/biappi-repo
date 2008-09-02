//
//  PSFeedAdditions.h
//  FeedCouch
//
//  Created by Antonio Malara on 22/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <PubSub/PubSub.h>

@interface PSEntry (PSEntryAddition)

- (NSAttributedString *)titleAttributedString;
- (NSAttributedString *)titleAttributedStringWithSizes:(int)uno e:(int)due;

@end
