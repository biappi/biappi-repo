//
//  TileManager.h
//  UilliMappe
//
//  Created by Antonio "Willy" Malara on 08/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMTile.h"
#import "RMTileSource.h"

extern NSString * TileManagerSelectionDidChange;
extern NSString * SelectingTilesToDownloadBegin;
extern NSString * SelectingTilesToDownloadEnd;

@interface TileManager : NSObject <RMTileSource>
{
	NSObject<RMTileSource> * tileSource;
	
	BOOL                     selectingTiles;
	NSMutableSet           * selectedTiles;
	
	NSMutableDictionary    * lruCache;
	NSMutableArray         * lruCacheOrder;
}

+ (TileManager *)sharedTileManager;

- (void)toggleSelectingTiles;
- (BOOL)isSelectingTiles;

- (void)toggleSelectionForTile:(RMTile)theTile;
- (BOOL)tileIsSelected:(RMTile)theTile;

@end
