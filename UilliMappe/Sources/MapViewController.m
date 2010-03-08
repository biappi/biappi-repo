//
//  MapViewController.m
//  UilliMappe
//
//  Created by Antonio "Willy" Malara on 08/03/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "MapViewController.h"
#import "RMTileImage.h"
#import "SelectableTileImageLayer.h"
#import "RMCoreAnimationRenderer.h"

NSString * SelectingTilesToDownloadBegin = @"SelectingTilesToDownloadBegin";
NSString * SelectingTilesToDownloadEnd   = @"SelectingTilesToDownloadEnd";

@implementation MapViewController

@synthesize mapView;
@synthesize selectTilesButton;

#pragma mark Housekeeping

+ (void)initialize;
{
	[RMTileImage setTileImageLayerClass:[SelectableTileImageLayer class]];
}

- (void)awakeFromNib;
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tileAddedInScreen:)
												 name:RMCARendererTileAdded
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tileRemovedInScreen:)
												 name:RMCARendererTileRemoved
											   object:nil];	
}

- (void)dealloc;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)viewDidLoad;
{
	[RMMapView class];
	
	[mapView setDelegate:self];
	[mapView setBackgroundColor:[UIColor grayColor]];
	
	[self loadPositionFromUserDefaults];
}

- (void)viewWillDisappear:(BOOL)animated;
{
	animated;	
	[self savePositionToUserDefaults];
}

#pragma mark Actions And User Interaction

- (void)selectTilesAction;
{
	if (selectingTiles == NO)
	{
		selectingTiles     = YES;
		mapView.enableZoom = NO;
		selectTilesButton.title = @"Done";
		[[NSNotificationCenter defaultCenter] postNotificationName:SelectingTilesToDownloadBegin
															object:nil];
	} else {
		selectingTiles     = NO;
		mapView.enableZoom = YES;
		selectTilesButton.title = @"DL Tiles";
		[[NSNotificationCenter defaultCenter] postNotificationName:SelectingTilesToDownloadEnd
															object:nil];
	}
}

- (void)mapView:(RMMapView *)map didTapOnTileImage:(RMTileImage *)tm;
{
	if (selectingTiles == NO)
		return;
	
	if ([tm.layer isKindOfClass:[SelectableTileImageLayer class]] == NO)
		return;
	
	SelectableTileImageLayer * theLayer = (SelectableTileImageLayer *) tm.layer;
	[theLayer tintGreen];
}

#pragma mark New Tiles Management

- (void)tileAddedInScreen:(NSNotification *)noti;
{
	if (selectingTiles == NO)
		return;
	
	RMTileImage * tileImage = [[noti userInfo] objectForKey:RMCARendererTileImage];
	
	SelectableTileImageLayer * theLayer = (SelectableTileImageLayer *) tileImage.layer;
	[theLayer tintR:1 G:1 B:1];
}

- (void)tileRemovedInScreen:(NSNotification *)noti;
{
	
}

#pragma mark User Defaults

- (void)savePositionToUserDefaults;
{
	CLLocationCoordinate2D center = mapView.contents.mapCenter;
	float mpp = mapView.contents.metersPerPixel;
	
	[[NSUserDefaults standardUserDefaults] setFloat:center.latitude  forKey:@"lat"];
	[[NSUserDefaults standardUserDefaults] setFloat:center.longitude forKey:@"lon"];
	[[NSUserDefaults standardUserDefaults] setFloat:mpp              forKey:@"mpp"];
}

- (void)loadPositionFromUserDefaults;
{
	CLLocationCoordinate2D center;
	float mpp;
	
	center.latitude  = [[NSUserDefaults standardUserDefaults] floatForKey:@"lat"];
	center.longitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"lon"];
	mpp = [[NSUserDefaults standardUserDefaults] floatForKey:@"mpp"];
	
	mpp = (mpp == 0) ? 1000 : mpp;
	
	mapView.contents.mapCenter      = center;
	mapView.contents.metersPerPixel = mpp;
}

@end
