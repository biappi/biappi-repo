//
//  SelectableTileImageLayer.m
//  UilliMappe
//
//  Created by Antonio "Willy" Malara on 08/03/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "SelectableTileImageLayer.h"
#import "MapViewController.h"
#import "TileManager.h"
#import "RMTileImage.h"

NSString * SelectableTileImageLayerDisplayTileInfoChanged = @"SelectableTileImageLayerDisplayTileInfoChanged";

@interface SelectableTileImageLayer()

@property(readonly) CALayer * insideLayer;

- (void)tintR:(float)r G:(float)g B:(float)b;
- (void)colorize;

@end

@implementation SelectableTileImageLayer

- (id)init;
{
	if ((self = [super init]) == nil)
		return nil;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(selectingTilesBegin)
												 name:SelectingTilesToDownloadBegin
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(selectingTilesEnd)
												 name:SelectingTilesToDownloadEnd
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(colorize)
												 name:TileManagerSelectionDidChange
											   object:nil];
	
	return self;
}

- (void)dealloc;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[insideLayer release];
	[super dealloc];
}

- (CALayer *)insideLayer;
{
	if (insideLayer != nil)
		return insideLayer;
	
	insideLayer = [[CALayer alloc] init];
	insideLayer.borderWidth = 2;
	
	NSMutableDictionary * customActions = [NSMutableDictionary dictionaryWithDictionary:[insideLayer actions]];
	
	[customActions setObject:[NSNull null] forKey:@"position"];
	[customActions setObject:[NSNull null] forKey:@"bounds"];
	
	insideLayer.actions = customActions;	
	
	[self addSublayer:insideLayer];
	
	return insideLayer;
}

- (void)tintR:(float)r G:(float)g B:(float)b;
{
	self.insideLayer.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:0.30].CGColor;
	self.insideLayer.borderColor     = [UIColor colorWithRed:r green:g blue:b alpha:1].CGColor;
}

- (void)tintGreen;
{
	[self tintR:0 G:1 B:0];
}

- (void)layoutSublayers;
{
	if ([[TileManager sharedTileManager] isSelectingTiles])
		[self colorize];
	
	insideLayer.frame = self.bounds;
}

- (void)colorize;
{
	if ([[TileManager sharedTileManager] tileIsSelected:self.tileImage.tile])
		[self tintR:0 G:1 B:0];
	else
		[self tintR:1 G:1 B:1];
}

- (void)selectingTilesBegin;
{
	[self tintR:1 G:1 B:1];
}

- (void)selectingTilesEnd;
{
	[self.insideLayer removeFromSuperlayer];
	[self.insideLayer release];
	insideLayer = nil;
}

@end
