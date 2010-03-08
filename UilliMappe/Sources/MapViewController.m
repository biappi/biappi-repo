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

NSString * SelectingTilesToDownloadBegin = @"SelectingTilesToDownloadBegin";
NSString * SelectingTilesToDownloadEnd   = @"SelectingTilesToDownloadEnd";

@implementation MapViewController

@synthesize mapView;
@synthesize selectTilesButton;

+ (void)initialize;
{
	[RMTileImage setTileImageLayerClass:[SelectableTileImageLayer class]];
}

- (void)viewDidLoad;
{
	[RMMapView class];
	
	[mapView setDelegate:self];
	[mapView setBackgroundColor:[UIColor grayColor]];
}

- (void)selectTilesAction;
{
	if (selectingTiles == NO)
	{
		selectingTiles     = YES;
		mapView.enableZoom = NO;
		selectTilesButton.title = @"Done";
		[[NSNotificationCenter defaultCenter] postNotificationName:SelectingTilesToDownloadBegin object:nil];
	} else {
		selectingTiles     = NO;
		mapView.enableZoom = YES;
		selectTilesButton.title = @"DL Tiles";
		[[NSNotificationCenter defaultCenter] postNotificationName:SelectingTilesToDownloadEnd object:nil];
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


@end
