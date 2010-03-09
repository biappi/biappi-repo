//
//  TileManager.m
//  UilliMappe
//
//  Created by Antonio "Willy" Malara on 08/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TileManager.h"
#import "RMOpenStreetMapSource.h"
#import "RMTileImage.h"

#define LRU_CACHE_SIZE 30

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

static NSUInteger NSArrayIndexOfObject(NSArray * array, id object)
{
	for (int i = 0; i < [array count]; i++)
		if ([object isEqualToString:[array objectAtIndex:i]])
			return i;
	
	return NSNotFound;
}

@interface TileManager ()

- (RMTileImage *)fetchFromCache:(RMTile)tile;
- (void)insertInCache:(RMTileImage *)tileImage;

@end


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
	tileSource    = [[RMOpenStreetMapSource alloc] init];
	
	lruCache      = [[NSMutableDictionary alloc] init];
	lruCacheOrder = [[NSMutableArray alloc] init];
	
	return self;
}

- (void)dealloc;
{
	[tileSource release];
	[selectedTiles release];
	[lruCache release];
	[lruCacheOrder release];
	[super dealloc];
}

#pragma mark Tile Fetching

-(RMTileImage *)tileImage:(RMTile)tile;
{
	RMTileImage * image = [self fetchFromCache:tile];
	
	if (image == nil)
	{
		image = [tileSource tileImage:tile];
		[self insertInCache:image];
	}
	
	return image;
}

#pragma mark Tile Selection Management

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

#pragma mark LRU Cache

- (RMTileImage *)fetchFromCache:(RMTile)tile;
{
	NSString    * tileString = TileToNSString(tile);
	RMTileImage * tileImage  = [lruCache objectForKey:tileString];
	
	if (tileImage == nil)
		return nil;
	
	[lruCacheOrder exchangeObjectAtIndex:NSArrayIndexOfObject(lruCacheOrder, tileString) withObjectAtIndex:0];
	
	return tileImage;
}

- (void)insertInCache:(RMTileImage *)tileImage;
{
	NSString * tileString = TileToNSString(tileImage.tile);
	
	if ([lruCacheOrder count] >= LRU_CACHE_SIZE)
	{
		[lruCache removeObjectForKey:[lruCacheOrder lastObject]];
		[lruCacheOrder removeLastObject];
	}
	
	[lruCache setObject:tileImage forKey:tileString];
	[lruCacheOrder insertObject:tileString atIndex:0];
}

#pragma mark RMTileSource Proxy

-(NSString *)tileURL:(RMTile)tile;
{
	NSLog(@"requested url   for: %@", TileToNSString(tile));
	return [tileSource tileURL:tile];
}

- (NSString *)tileFile:(RMTile)tile;
{
	NSLog(@"requested file  for: %@", TileToNSString(tile));
	return [tileSource tileFile:tile];
}

- (NSString *)tilePath;
{
	return [tileSource tilePath];
}

- (id<RMMercatorToTileProjection>)mercatorToTileProjection;
{
	return [tileSource mercatorToTileProjection];
}

- (RMProjection *)projection;
{
	return [tileSource projection];
}

- (float)minZoom;
{
	return [tileSource minZoom];
}

- (float)maxZoom;
{
	return [tileSource maxZoom];
}

- (void)setMinZoom:(NSUInteger)aMinZoom;
{
	[tileSource setMinZoom:aMinZoom];
}

- (void)setMaxZoom:(NSUInteger)aMaxZoom;
{
	[tileSource setMaxZoom:aMaxZoom];
}

- (RMSphericalTrapezium)latitudeLongitudeBoundingBox;
{
	return [tileSource latitudeLongitudeBoundingBox];
}

- (void)didReceiveMemoryWarning;
{
	[tileSource didReceiveMemoryWarning];
}

- (NSString *)uniqueTilecacheKey;
{
	return [tileSource uniqueTilecacheKey];
}

- (NSString *)shortName;
{
	return [tileSource shortName];
}

- (NSString *)longDescription;
{
	return [tileSource longDescription];
}

- (NSString *)shortAttribution;
{
	return [tileSource shortAttribution];
}

- (NSString *)longAttribution;
{
	return [tileSource longAttribution];
}

- (void)removeAllCachedImages;
{
	[lruCache release];
	[lruCacheOrder release];
	
	lruCache      = [[NSMutableDictionary alloc] init];
	lruCacheOrder = [[NSMutableArray alloc] init];
}

@end
