//
//  GameView.m
//  REminescence
//
//  Created by Antonio "Willy" Malara on 06/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "REminescenceGameView.h"

@implementation REminescenceGameView

- (void)dealloc;
{
    [super dealloc];
}

- (void)drawRect:(CGRect)rect;
{
	if (imaggio == NULL)
		return;
	
	UIImage * im = [UIImage imageWithCGImage:imaggio];
	[im drawAtPoint:CGPointZero];	
}

- (void)setImage:(CGImageRef)image;
{
	imaggio = image;
}

@end
