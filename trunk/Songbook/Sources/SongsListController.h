//
//  SongsListController.h
//  Songbook
//
//  Created by Antonio "Willy" Malara on 22/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongsListController : UITableViewController
{
	NSString * artist;
	NSArray  * songs;
}

- (id)initWithArtist:(NSString *)a;

@end
