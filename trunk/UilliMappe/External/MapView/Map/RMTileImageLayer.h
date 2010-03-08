//
//  RMTileImageLayer.h
//  MapView
//
//  Created by Antonio "Willy" Malara on 08/03/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <QuartzCore/CoreAnimation.h>

@class RMTileImage;

@interface RMTileImageLayer : CALayer
{
	RMTileImage * tileImage;
}

@property(nonatomic, readonly) RMTileImage * tileImage;

@end
