//
//  SelectableTileImageLayer.h
//  UilliMappe
//
//  Created by Antonio "Willy" Malara on 08/03/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "RMTileImageLayer.h"

@interface SelectableTileImageLayer : RMTileImageLayer
{
	CALayer * insideLayer;
}

- (void)tintGreen;

@end
