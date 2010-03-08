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
}

@property(nonatomic, retain) IBOutlet RMMapView       * mapView;
@property(nonatomic, retain) IBOutlet UIBarButtonItem * selectTilesButton;;

- (IBAction)selectTilesAction;

- (void)savePositionToUserDefaults;
- (void)loadPositionFromUserDefaults;

@end
