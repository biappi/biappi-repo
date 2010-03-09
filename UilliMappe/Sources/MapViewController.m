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
#import "TileManager.h"

@interface MapViewController ()

- (void)updateLevelsLabel;

@end


@implementation MapViewController

@synthesize mapView;
@synthesize selectTilesButton;
@synthesize statusView;
@synthesize statusLabel;
@synthesize downloadToolbar;
@synthesize numberOfLevels;

#pragma mark Housekeeping

+ (void)initialize;
{
	[RMTileImage setTileImageLayerClass:[SelectableTileImageLayer class]];
}

- (void)awakeFromNib;
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(selectingTilesBegin)
												 name:SelectingTilesToDownloadBegin
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(selectingTilesEnd)
												 name:SelectingTilesToDownloadEnd
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateLevelsLabel)
												 name:TileManagerSelectionDidChange
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
	[mapView.contents setTileSourceNoCache:[TileManager sharedTileManager]];
	
	[self loadPositionFromUserDefaults];
}

- (void)viewDidUnload;
{
	self.mapView = nil;
	self.selectTilesButton = nil;
	self.statusView = nil;
	self.statusLabel = nil;
}

- (void)viewWillDisappear:(BOOL)animated;
{
	[self savePositionToUserDefaults];
}

#pragma mark Actions And User Interaction

- (void)selectTilesAction;
{
	[[TileManager sharedTileManager] toggleSelectingTiles];
}

- (void)mapView:(RMMapView *)map didTapOnTileImage:(RMTileImage *)tm;
{
	if ([[TileManager sharedTileManager] isSelectingTiles] == NO)
		return;
	
	if ([tm.layer isKindOfClass:[SelectableTileImageLayer class]] == NO)
		return;
	
	[[TileManager sharedTileManager] toggleSelectionForTile:tm.tile];
}

- (void)selectingTilesBegin;
{
	downloadToolbar.hidden = NO;
	[self updateLevelsLabel];
}

- (void)selectingTilesEnd;
{
	downloadToolbar.hidden = YES;
}

- (void)updateLevelsLabel;
{
	numberOfLevels.title = [NSString stringWithFormat:@"%d Levels %d Tiles",
							[TileManager sharedTileManager].numberOfLevelsToSelect,
							[TileManager sharedTileManager].numberOfTilesSelected];
}

- (IBAction)doneDownload;
{
	[[TileManager sharedTileManager] toggleSelectingTiles];
}

- (IBAction)addLevel;
{
	[[TileManager sharedTileManager] increaseNumberOfLevelsToSelect];
	[self updateLevelsLabel];
}

- (IBAction)subtractLevel;
{
	[[TileManager sharedTileManager] decreaseNumberOfLevelsToSelect];
	[self updateLevelsLabel];
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
