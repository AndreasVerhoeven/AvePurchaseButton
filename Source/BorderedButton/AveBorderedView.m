//
//  AveBorderedView.m
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

#import "AveBorderedView.h"

@implementation AveBorderedView

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self != nil)
	{
		[self initDefaults];
		[self updateBorder];
	}
	
	return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		[self initDefaults];
		[self updateBorder];
	}
	
	return self;
}

-(instancetype)init
{
	self = [super init];
	if(self != nil)
	{
		[self initDefaults];
		[self updateBorder];
	}
	
	return self;
}

-(void)initDefaults
{
	_cornerRadius = 4;
	_borderWidth = 1;
	_borderColor = [UIColor blueColor];
}

-(void)updateBorder
{
	self.layer.borderWidth = self.borderWidth;
	self.layer.borderColor = self.borderColor.CGColor;
	self.layer.cornerRadius = self.cornerRadius;
}

-(void)setBorderColor:(UIColor *)borderColor
{
	_borderColor = borderColor;
	[self updateBorder];
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
	_borderWidth = borderWidth;
	[self updateBorder];
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
	_cornerRadius = cornerRadius;
	[self updateBorder];
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)key
{
	if([key isEqualToString:@"borderColor"] || [key isEqualToString:@"cornerRadius"] || [key isEqualToString:@"borderWidth"])
	{
		// piggy back on the animation for opacity, which only will be non nil if we are in an animation block.
		// This way, we will only animate those properties when in an animation block.
		CABasicAnimation* animation = (CABasicAnimation*)[layer actionForKey:@"opacity"];
		if([animation isKindOfClass:[CABasicAnimation class]])
		{
			animation.keyPath = key;
			animation.fromValue = [layer valueForKey:key];
			animation.toValue = nil;
			animation.byValue = nil;
			return animation;
		}
	}
	
	
	return [super actionForLayer:layer forKey:key];
}

@end
