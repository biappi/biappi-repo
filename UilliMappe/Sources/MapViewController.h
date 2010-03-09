//
//  MapViewController.h
//  UilliMappe
//
//  Created by Antonio "Willy" Malara on 08/03/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMMapView.h"

@interface MapViewController : UIViewController <RMMapViewDelegate>
{
	RMMapView       * mapView;
	UIBarButtonItem * selectTilesButton;
	UIView          * statusView;
	UILabel         * statusLabel;
	
	UIToolbar       * downloadToolbar;
	UIBarButtonItem * numberOfLevels;
}

@property(nonatomic, retain) IBOutlet RMMapView       * mapView;
@property(nonatomic, retain) IBOutlet UIBarButtonItem * selectTilesButton;
@property(nonatomic, retain) IBOutlet UIView          * statusView;
@property(nonatomic, retain) IBOutlet UILabel         * statusLabel;
@property(nonatomic, retain) IBOutlet UIToolbar       * downloadToolbar;
@property(nonatomic, retain) IBOutlet UIBarButtonItem * numberOfLevels;

- (IBAction)selectTilesAction;

- (IBAction)doneDownload;
- (IBAction)addLevel;
- (IBAction)subtractLevel;

- (void)savePositionToUserDefaults;
- (void)loadPositionFromUserDefaults;

@end
