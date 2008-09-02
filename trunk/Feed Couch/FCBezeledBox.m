//
//  FCEntryTitle.m
//  FeedCouch
//
//  Created by Antonio Malara on 20/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FCBezeledBox.h"

static NSArray * _selectedFilters;
static NSArray * _unselectedFilters;
static CABasicAnimation * _selectedAnimation;

@implementation FCBezeledBox

+ (NSArray *)selectedFilters;
{
	//if (_selectedFilters == nil)
	//{
		CIFilter * bloomFilter = [CIFilter filterWithName:@"CIBloom"];
		[bloomFilter setDefaults];
		[bloomFilter setValue:[NSNumber numberWithFloat:5.0] forKey:@"inputRadius"];
		[bloomFilter setName:@"pulseFilter"];
		_selectedFilters = [NSArray arrayWithObject:bloomFilter];
	//}
	
	return _selectedFilters;
}

+ (NSArray *)unselectedFilters;
{
	//if (_unselectedFilters == nil)
	//{
		CIFilter * blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
		[blurFilter setDefaults];
		[blurFilter setValue:[NSNumber numberWithFloat:2] forKey:@"inputRadius"];
		
		CIFilter * satFilter = [CIFilter filterWithName:@"CIColorControls"];
		[satFilter setDefaults];
		[satFilter setValue:[NSNumber numberWithFloat:0.6] forKey:@"inputSaturation"];
		[satFilter setValue:[NSNumber numberWithFloat:0.2] forKey:@"inputBrightness"];
		
		_unselectedFilters = [NSArray arrayWithObjects:blurFilter, satFilter, nil];
	//}
	
	return _unselectedFilters;
}

+ (CABasicAnimation *)selectedAnimation;
{
	//if (_selectedAnimation == nil)
	//{
		_selectedAnimation = [CABasicAnimation animation];
		_selectedAnimation.keyPath = @"filters.pulseFilter.inputIntensity";
		_selectedAnimation.fromValue = [NSNumber numberWithFloat: 0.5];
		_selectedAnimation.toValue = [NSNumber numberWithFloat: 2];
		_selectedAnimation.duration = 1.0;
		_selectedAnimation.repeatCount = 1e100f;
		_selectedAnimation.autoreverses = YES;
		_selectedAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	//}
	
	return _selectedAnimation;
}

- (id)initWithAttributedString:(NSAttributedString *)aString;
{
	if ([super init] == nil)
		return nil;
	
	self.borderColor = CGColorCreateGenericRGB(1, 1, 1, 1);
	self.borderWidth = 2;
	self.cornerRadius = 20;
	self.masksToBounds = YES;
	[self buildGradient];
	[self setState:kUnselectedState];
	
	title = [CATextLayer layer];
	title.string = aString;
	
	[self addSublayer:title];
	[self layoutSublayers];
	return self;
}

- (void)buildGradient;
{
	// build a gradient bitmap and set it as self.content, 100x100 units will do fine, that can be stretched with few artifacts.
	
	CGRect r;
	r.origin = CGPointZero;
	r.size.width = 100;
	r.size.height = 100;
	
	size_t bytesPerRow = 4 * r.size.width;
	
	void * bitmapData = malloc(bytesPerRow * r.size.height);
	
	CGContextRef context = CGBitmapContextCreate(bitmapData,
												 r.size.width,
												 r.size.height,
												 8,
												 bytesPerRow, 
												 CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB),
												 kCGImageAlphaPremultipliedFirst);
		
	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed:0.95 green:0.25 blue:0.83 alpha:1]
														 endingColor:[NSColor colorWithDeviceRed:0.48 green:0.10 blue:0.45 alpha:1]];

	NSGraphicsContext *nsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:context flipped:NO];
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:nsContext];
	[gradient drawInRect:NSMakeRect(0, 0, r.size.width, r.size.height) angle:90];
	[NSGraphicsContext restoreGraphicsState];
	
	CGImageRef gradientImage = CGBitmapContextCreateImage(context);
	self.contents = (id)gradientImage;
	CGContextRelease(context);
	CGImageRelease(gradientImage);
	free(bitmapData);	
}

- (CGSize)preferredFrameSize;
{
	CGSize size = [title preferredFrameSize];

	size.width += 20;
	size.height += 20;
	
	return size;
}

- (void)layoutSublayers;
{
	CGRect frame = self.bounds;
	
	frame.size.height -= 20;
	frame.size.width -= 20;
	frame.origin.x = 10;
	frame.origin.y = 10;

	title.frame = frame;
}

- (void)setState:(bezeledBoxStates)newState;
{
	switch (newState)
	{
		case kUnselectedState:
			self.filters = [FCBezeledBox unselectedFilters];
			self.opacity = 0.8;
			self.cornerRadius = 20;
			[self removeAnimationForKey:@"pulseAnimation"];
			break;
			
		case kSelectedState:
			self.filters = [FCBezeledBox selectedFilters];
			self.opacity = 1;
			self.cornerRadius = 20;
			[self addAnimation:[FCBezeledBox selectedAnimation] forKey:@"pulseAnimation"];
			break;
			
		case kTopBarState:
			self.filters = nil;
			self.opacity = 1;
			self.cornerRadius = 0;
			[self removeAnimationForKey:@"pulseAnimation"];
			break;
	}
}

- (void)setString:(NSAttributedString *)newString;
{
	title.string = newString;
	[self setNeedsLayout];
}

@end
