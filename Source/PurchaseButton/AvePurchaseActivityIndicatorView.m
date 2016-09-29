//
//  AvePurchaseActivityIndicatorView.m
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Andreas Verhoeven
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "AvePurchaseActivityIndicatorView.h"

static NSString* const kAvePurchaseActivityIndicatorViewRotationAnimationKey = @"AvePurchaseActivityIndicatorViewRotationAnimationKey";

@implementation AvePurchaseActivityIndicatorView
{
	UIImageView* _imageView;
	BOOL _animating;
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)ensureImageView
{
	if(nil == _imageView)
	{
		_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[self addSubview:_imageView];
	}
}

-(void)setTintColor:(UIColor *)tintColor
{
	if([self respondsToSelector:@selector(tintColor)]) // for iOS6 compatibility
	{
		[super setTintColor:tintColor];
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGSize size = self.bounds.size;
	_imageView.bounds = CGRectMake(0, 0, size.width, size.height);
	_imageView.center = CGPointMake(size.width * 0.5, size.height * 0.5);
}

#pragma mark - Animation

-(void)startAnimating
{
	if(!_animating)
	{
		_animating = YES;
		
		// CA animations are removed when an app moves to the background, so we need to monitor for the app going to the
		// foreground in order to restart the rotation animation.
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
	}
	
	[self ensureImageView];
	[self ensureImageViewImage];
	[self ensureRotationAnimation];
}

-(void)stopAnimating
{
	if(_animating)
	{
		_animating = NO;
		[_imageView.layer removeAnimationForKey:kAvePurchaseActivityIndicatorViewRotationAnimationKey];
		
		// not animating anymore, so no need to know when the app goes to the foreground
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
	}
}

-(BOOL)isAnimating
{
	return _animating;
}

-(void)ensureRotationAnimation
{
	if([_imageView.layer animationForKey:kAvePurchaseActivityIndicatorViewRotationAnimationKey] == nil)
	{
		CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
		rotationAnimation.toValue = @(M_PI * 2.0);
		rotationAnimation.duration = 1.0;
		rotationAnimation.cumulative = YES;
		rotationAnimation.repeatCount =  HUGE_VALF;
		[_imageView.layer addAnimation:rotationAnimation forKey:kAvePurchaseActivityIndicatorViewRotationAnimationKey];
	}
}

-(void)didMoveToWindow
{
	[super didMoveToWindow];
	
	// CA animations are also removed when a view is removed from a window,
	// so we need to restart the rotation animation if needed
	[self ensureAnimatingWhenNeeded];
}

-(void)_applicationWillEnterForeground
{
	[self ensureAnimatingWhenNeeded];
}

-(void)ensureAnimatingWhenNeeded
{
	if(_animating && self.window != nil)
	{
		[self ensureImageViewImage];
		[self ensureRotationAnimation];
	}
}

-(void)setFrame:(CGRect)frame
{
	BOOL sizeChanged = !CGSizeEqualToSize(frame.size, self.bounds.size);
	[super setFrame:frame];
	if(sizeChanged)
	{
		[self resetImageViewImage];
	}
}

-(CGFloat)lineWidth
{
	return _lineWidth == 0 ? 1 : _lineWidth;
}

#pragma mark - Image

-(void)ensureImageViewImage
{
	if(_imageView.image == nil)
	{
		_imageView.image = [self imageForAnimation];
	}
}

-(void)resetImageViewImage
{
	_imageView.image = nil;
	if(_animating && self.window != nil)
	{
		[self ensureImageViewImage];
	}
}

-(UIImage*)imageForAnimation
{
	CGRect rc = self.bounds;
	if(CGRectIsEmpty(rc) || CGRectIsNull(rc))
		return nil;
	
	UIGraphicsBeginImageContextWithOptions(rc.size, NO, 0.0);
	
	// use blue, for iOS6 compatibility, since the image won't get tinted on iOS6
	[[UIColor colorWithRed:3.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1] setStroke];
	
	// create a circle
	CGContextSaveGState(UIGraphicsGetCurrentContext());
	UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:rc];
	path.lineWidth = self.lineWidth * 2;
	[path addClip];
	[path stroke];
	CGContextRestoreGState(UIGraphicsGetCurrentContext());
	
	// cut-out a hole
	UIRectFillUsingBlendMode(CGRectMake(rc.size.width - 6, rc.size.height / 2.0 - 2, 6, 6), kCGBlendModeClear);
	
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return [image respondsToSelector:@selector(imageWithRenderingMode:)] ? [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : image;
}

@end
