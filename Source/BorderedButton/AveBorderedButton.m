//
// AveBorderedButton.m
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

#import "AveBorderedButton.h"
#import "AveBorderedView.h"

CGFloat kAveBorderedButtonDefaultBorderWidth = 1.0;
CGFloat kAveBorderedButtonDefaultCornerRadius = 4.0;

@implementation AveBorderedButton
{
	AveBorderedView* _borderView; // the border around the button
	UIImageView* _fillView; // the highlighting 'fill' when the button is tapped
	UIView* _labelClipView; // the title label is clipped
	UIImageView* _accessoryImageView; // accessoryImageView
	UIView* _accessoryAndLabelView;
}

#pragma mark - Initialization

-(void)setup
{
	if(nil == _titleLabel)
	{
		// defaults for properties
		_cornerRadius = kAveBorderedButtonDefaultCornerRadius;
		_borderWidth = kAveBorderedButtonDefaultBorderWidth;
		
		// view defaults
		self.backgroundColor = [UIColor clearColor];
		
		// the border view
		_borderView = [[AveBorderedView alloc] initWithFrame:self.bounds];
		_borderView.backgroundColor = [UIColor clearColor];
		_borderView.userInteractionEnabled = NO;
		_borderView.layer.cornerRadius = self.cornerRadius;
		_borderView.layer.borderWidth = self.borderWidth;
		[self addSubview:_borderView];
		
		// the title label is clipped inside this view
		_labelClipView = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, 2, 2)];
		_labelClipView.backgroundColor = [UIColor clearColor];
		_labelClipView.opaque = NO;
		_labelClipView.clipsToBounds = YES;
		_labelClipView.userInteractionEnabled = NO;
		[self addSubview:_labelClipView];
		
		_accessoryAndLabelView = [[UIView alloc] initWithFrame:_labelClipView.bounds];
		_accessoryAndLabelView.backgroundColor = [UIColor clearColor];
		_accessoryAndLabelView.opaque = NO;
		[_labelClipView addSubview:_accessoryAndLabelView];
		
		_accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[_accessoryAndLabelView addSubview:_accessoryImageView];
		
		// the title label itself
		_titleLabel = [[UILabel alloc] initWithFrame:_accessoryImageView.bounds];
		_titleLabel.opaque = NO;
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.font = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
		_titleLabel.userInteractionEnabled = NO;
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		[_accessoryAndLabelView addSubview:_titleLabel];
		
		[self updateTintColors];
	}
}

-(id)init
{
	self = [super init];
	if(self != nil)
	{
		[self setup];
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self != nil)
	{
		[self setup];
	}
	
	return self;
}

-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		[self setup];
	}
	
	return self;
}

-(CGSize)sizeThatFits:(CGSize)size
{
	CGSize s = [self.titleLabel sizeThatFits:size];
	if(self.image != nil)
	{
		s.width += s.height - 8;
	}
	
	s.width += 20; // add some spacing
	s.height += 8;
	s.width = ceilf(s.width);
	s.height = ceilf(s.height);
	return s;
}

#pragma mark - Properties

-(void)setCornerRadius:(CGFloat)cornerRadius
{
	if(cornerRadius != _cornerRadius)
	{
		_cornerRadius = cornerRadius;
		_borderView.layer.cornerRadius = self.cornerRadius;
	}
}


-(void)setBorderWidth:(CGFloat)borderWidth
{
	if(borderWidth != _borderWidth)
	{
		_borderWidth = borderWidth;
		_borderView.layer.borderWidth = self.borderWidth;
	}
}

-(BOOL)shouldShowFillView
{
	return self.highlighted;
}

#pragma mark - Layout code
-(void)layoutSubviews
{
	[super layoutSubviews];
	_borderView.frame = self.bounds;
	_fillView.frame = self.bounds;
	_labelClipView.frame = CGRectInset(_borderView.bounds, 2, 2);
	_accessoryAndLabelView.frame = UIEdgeInsetsInsetRect(_labelClipView.bounds, self.titleEdgeInsets);
	
	_accessoryImageView.frame = _accessoryImageView.image != nil ? CGRectInset(CGRectMake(0, 0, CGRectGetHeight(_accessoryAndLabelView.bounds), CGRectGetHeight(_accessoryAndLabelView.bounds)), 4, 4) : CGRectZero;
	_titleLabel.frame = CGRectMake(CGRectGetMaxX(_accessoryImageView.frame), 0, CGRectGetWidth(_accessoryAndLabelView.bounds) - CGRectGetMaxX(_accessoryImageView.frame), CGRectGetHeight(_accessoryAndLabelView.bounds));
}


#pragma mark - FillView

-(void)ensureFillView
{
	if(nil == _fillView)
	{
		_fillView = [[UIImageView alloc] initWithFrame:self.bounds];
		_fillView.userInteractionEnabled = NO;
		_fillView.alpha = 0;
		_fillView.layer.cornerRadius = self.cornerRadius;
		[self insertSubview:_fillView aboveSubview:_borderView];
	}
}

-(UIImage*)fillViewMaskImage
{
	CGFloat actualWidth = _fillView.bounds.size.width;
	CGFloat actualHeight = _fillView.bounds.size.height;
	CGFloat deviceScale = [UIScreen mainScreen].scale;
 
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef context = CGBitmapContextCreate(nil, actualWidth * deviceScale, actualHeight * deviceScale, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
	CGContextScaleCTM(context, deviceScale, deviceScale);
	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextFillRect(context, _fillView.bounds);
	
	CGContextSetBlendMode(context, kCGBlendModeMultiply);
	CGContextDrawImage(context, [_accessoryImageView convertRect:_accessoryImageView.bounds toView:_fillView], self.image.CGImage);
 
	CGImageRef grayImage = CGBitmapContextCreateImage(context);
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);
	
	return [UIImage imageWithCGImage:grayImage scale:deviceScale orientation:UIImageOrientationUp];
}

-(UIImage*)fillViewImage
{
	UIGraphicsBeginImageContextWithOptions(_fillView.bounds.size, NO, 0.0);
	
	[self.compatibleTintColor setFill]; // This image won't get tinted on iOS6, so pre-fill it with the right color
	
	// fill the background with a rounded corner
	UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
	[path fill];
	
	// cut out the title by drawing the title label with a 'clear' blend mode
	CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
	[_titleLabel drawTextInRect:[self.titleLabel convertRect:self.titleLabel.bounds toView:_fillView]];
	
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if(self.image != nil)
	{
		CGImageRef cgImage = CGImageCreateWithMask(image.CGImage, self.fillViewMaskImage.CGImage);
		image = [UIImage imageWithCGImage:cgImage];
	}
	
	return [image respondsToSelector:@selector(imageWithRenderingMode:)] ? [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : image;
}

-(void)updateFillView
{
	[self ensureFillView];
	_fillView.image = [self fillViewImage];
}

-(void)updateFillViewWhenNeeded
{
	_fillView.image = nil;
	if(_fillView.alpha != 0)
	{
		[self updateFillView];
	}
}

#pragma mark - Highlighting

-(void)updateHighlightedStateAnimated
{
	[self updateFillView];
	
	[UIView animateWithDuration:0.45 animations:^{
		_fillView.alpha = [self shouldShowFillView] ? 1 : 0;
		_accessoryAndLabelView.alpha = [self shouldShowFillView] ? 0 : 1;
	} completion:nil];
}

-(void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
	[self updateHighlightedStateAnimated];
}

#pragma mark - set Text
-(void)setTitle:(NSString *)title
{
	self.titleLabel.text = title;
	[self updateFillViewWhenNeeded];
}

-(NSString*)title
{
	return self.titleLabel.text;
}

-(void)setAttributedTitle:(NSAttributedString *)attributedTitle
{
	self.titleLabel.attributedText = attributedTitle;
	[self updateFillViewWhenNeeded];
}

-(NSAttributedString*)attributedTitle
{
	return self.titleLabel.attributedText;
}

#pragma mark - Set Image
-(void)setImage:(UIImage *)image
{
	_accessoryImageView.image = image;
	[self updateFillViewWhenNeeded];
}

-(UIImage*)image
{
	return _accessoryImageView.image;
}

#pragma mark - responding to updates
-(void)setFrame:(CGRect)frame
{
	BOOL sizeChanged = !CGSizeEqualToSize(frame.size, self.bounds.size);
	[super setFrame:frame];
	if(sizeChanged)
	{
		[self updateFillViewWhenNeeded];
	}
}

#pragma mark - set TintColor

-(BOOL)supportsTintColor
{
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7;
}

-(UIColor*)compatibleTintColor
{
	if([self supportsTintColor])
		return self.tintColor;
	else
		return [UIColor colorWithRed:3.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1];
}

-(void)setTintColor:(UIColor *)tintColor
{
	if([self supportsTintColor])
	{
		[super setTintColor:tintColor];
		[self updateTintColors];
	}
}

-(void)tintColorDidChange
{
	[super tintColorDidChange];
	[self updateTintColors];
}

-(void)didMoveToWindow
{
	[super didMoveToWindow];
	[self updateTintColors];
}

-(void)updateTintColors
{
	_borderView.layer.borderColor = self.compatibleTintColor.CGColor;
	_titleLabel.textColor = self.compatibleTintColor;
}

@end
