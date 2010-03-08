//
//  TileManager.m
//  UilliMappe
//
//  Created by Antonio "Willy" Malara on 08/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TileManager.h"

NSString * TileManagerSelectionDidChange = @"TileManagerSelectionDidChange";
NSString * SelectingTilesToDownloadBegin = @"SelectingTilesToDownloadBegin";
NSString * SelectingTilesToDownloadEnd   = @"SelectingTilesToDownloadEnd";

NSString * TileToNSString(RMTile tile)
{
	return [NSString stringWithFormat:@"%d-%d-%d", tile.x, tile.y, tile.zoom];
}

RMTile NSStringToTile(NSString * string)
{
	RMTile tile;
	NSArray * comps = [string componentsSeparatedByString:@"-"];
	
	tile.x    = [[comps objectAtIndex:0] intValue];
	tile.y    = [[comps objectAtIndex:2] intValue];
	tile.zoom = [[comps objectAtIndex:2] intValue];
	
	return tile;
}

@implementation TileManager

+ (TileManager *)sharedTileManager;
{
	static TileManager * theManager = nil;
	
	if (theManager == nil)
		theManager = [[TileManager alloc] init];
	
	return theManager;
}

- (id)init;
{
	if ((self = [super init]) == nil)
		return nil;
	
	selectedTiles = [[NSMutableSet alloc] init];
	
	return self;
}

- (void)dealloc;
{
	[selectedTiles release];
	[super dealloc];
}

- (void)toggleSelectingTiles;
{
	selectingTiles = !selectingTiles;
	
	NSString * notification = (selectingTiles == YES) ? SelectingTilesToDownloadBegin : SelectingTilesToDownloadEnd;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notification
														object:nil];	
}

- (BOOL)isSelectingTiles;
{
	return selectingTiles;
}

- (void)toggleSelectionForTile:(RMTile)theTile;
{
	NSString * newTile = TileToNSString(theTile);
	NSString * tile    = [selectedTiles member:newTile];
	
	if (tile != nil)
		[selectedTiles removeObject:tile];
	else
		[selectedTiles addObject:newTile];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:TileManagerSelectionDidChange
														object:nil];
}

- (BOOL)tileIsSelected:(RMTile)theTile;
{
	return ([selectedTiles member:TileToNSString(theTile)] != nil);
}

@end
