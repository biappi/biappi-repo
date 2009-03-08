//
//  SongViewController.h
//  Songbook
//
//  Created by Antonio "Willy" Malara on 24/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>
{
	NSInteger         songID;
	NSDictionary    * song;
	UIWebView       * songView;
	NSTimer         * scrollTimer;
	UIBarButtonItem * toolsBarButton;
	UIBarButtonItem * actionBarButton;
	UIBarButtonItem * stopScrollingButton;
	UIBarButtonItem * scrollingSpeedButton;
	NSInteger         scrollingSpeed;
}

- (id)initWithSongID:(NSInteger)songid;

@end
