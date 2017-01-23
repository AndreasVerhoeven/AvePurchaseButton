//
//  AvePurchaseButton.m
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

#import "AvePurchaseButton.h"
#import "AvePurchaseActivityIndicatorView.h"
#import "AveBorderedButton.h"

@implementation AvePurchaseButton
{
	AveBorderedButton* _button;
	AvePurchaseActivityIndicatorView* _activityIndicatorView;
	
	NSString* _normalTitle;
	NSString* _confirmationTitle;
	
	NSAttributedString* _attributedNormalTitle;
	NSAttributedString* _attributedConfirmationTitle;
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

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self != nil)
	{
		[self setup];
	}
	
	return self;
}

-(void)setup
{
	self.clearsContextBeforeDrawing = YES;
	self.backgroundColor = [UIColor clearColor];

	self.confirmationColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1];
	
	_button = [[AveBorderedButton alloc] initWithFrame:self.bounds];
	_button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	_button.userInteractionEnabled = NO;
	[self addSubview:_button];
	
	_activityIndicatorView = [[AvePurchaseActivityIndicatorView alloc] init];
	_activityIndicatorView.userInteractionEnabled = NO;
	[self addSubview:_activityIndicatorView];
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	
	CGFloat progressSize = self.bounds.size.height;
	CGRect progressFrame = CGRectMake(self.bounds.size.width - progressSize,0, progressSize, progressSize);
	_activityIndicatorView.frame = progressFrame;
	
	if(self.buttonState != AvePurchaseButtonStateProgress)
	{
		_button.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
	}
	else
	{
		_button.frame = progressFrame;
	}
}

-(void)setImage:(UIImage *)image
{
	_button.image = image;
}

-(UIImage*)image
{
	return _button.image;
}

-(void)setButtonState:(AvePurchaseButtonState)buttonState
{
	[self setButtonState:buttonState animated:NO];
}

-(void)stopProgressAnimation
{
	_activityIndicatorView.alpha = 0;
	_button.alpha = 1;
	[_activityIndicatorView stopAnimating];
}

-(void)configureButtonForProgressState
{
	_button.cornerRadius = self.bounds.size.height / 2.0;
	_button.titleEdgeInsets = UIEdgeInsetsMake(0, self.bounds.size.height, 0, -(self.bounds.size.width - self.bounds.size.height) - self.bounds.size.height);
	_button.frame = CGRectMake(self.bounds.size.width - self.bounds.size.height, 0, self.bounds.size.height, self.bounds.size.height);
}

-(void)configureButtonForRegularState
{
	_button.cornerRadius = kAveBorderedButtonDefaultCornerRadius;
	_button.titleEdgeInsets = UIEdgeInsetsZero;
	_button.frame = self.bounds;
}

-(void)setButtonState:(AvePurchaseButtonState)buttonState animated:(BOOL)animated
{
	if(buttonState != self.buttonState)
	{
		_buttonState = buttonState;
		[self updateTintColors];
		[self updateTitle];
		
		if(self.buttonState == AvePurchaseButtonStateProgress)
		{
			if(animated)
			{
				// don't animate the button highlight state. (use iOS6 compatible transactions, instead of performWithoutAnimation:)
				[CATransaction begin];
				[CATransaction setDisableActions:YES];
				_button.highlighted = NO;
				[CATransaction commit];
				
				[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
					[self configureButtonForProgressState];
				} completion:^(BOOL finished){
					if(self.buttonState == AvePurchaseButtonStateProgress)
					{
						[self updateTintColors];
						[UIView animateWithDuration:0.5 animations:^{
							_button.alpha = 0;
							_activityIndicatorView.alpha = 1;
							[_activityIndicatorView startAnimating];
						}];
					}
				}];
			}
			else
			{
				[self configureButtonForProgressState];
				
				_button.alpha = 0;
				_activityIndicatorView.alpha = 1;
				[_activityIndicatorView startAnimating];
				[self setNeedsLayout];
			}
		}
		else if(self.buttonState == AvePurchaseButtonStateNormal)
		{
			_button.alpha = 1;
			_activityIndicatorView.alpha = 0;
			
			if(animated)
			{
				[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
					[self configureButtonForRegularState];
				} completion:^(BOOL finished){
					[self updateTintColors];
				}];
			}
			else
			{
				[self configureButtonForRegularState];
				[self setNeedsLayout];
			}
		}
		else if(self.buttonState == AvePurchaseButtonStateConfirmation)
		{
			[self configureButtonForRegularState];
			[self setNeedsLayout];
		}
	}
	else if(self.buttonState == AvePurchaseButtonStateProgress && !animated)
	{
		// make sure we restart animation in re-used TableViewCells: they remove
		// all subview animations when they get reused.
		[_activityIndicatorView startAnimating];
	}
}


- (void)setNormalColor:(UIColor *)normalColor
{
	_normalColor = normalColor;
	[self updateTintColors];
}

-(void)setNormalTitle:(NSString *)normalTitle
{
	_normalTitle = [normalTitle copy];
	_attributedNormalTitle = nil;
	[self updateTitle];
}

-(NSString*)normalTitle
{
	if(_normalTitle != nil)
		return _normalTitle;
	else if(_attributedNormalTitle != nil)
		return _attributedNormalTitle.string;
	else
		return nil;
}

-(void)setAttributedNormalTitle:(NSAttributedString *)attributedNormalTitle
{
	_attributedNormalTitle = [attributedNormalTitle copy];
	_normalTitle = nil;
	[self updateTitle];
}

-(NSAttributedString*)attributedNormalTitle
{
	if(_attributedNormalTitle != nil)
		return _attributedNormalTitle;
	else if(_normalTitle != nil)
		return [[NSAttributedString alloc] initWithString:_normalTitle];
	else
		return nil;
}

- (void)setConfirmationColor:(UIColor *)confirmationColor
{
	_confirmationColor = confirmationColor;
	[self updateTintColors];
}

-(void)setConfirmationTitle:(NSString *)confirmationTitle
{
	_confirmationTitle = [confirmationTitle copy];
	_attributedConfirmationTitle = nil;
	[self updateTitle];
}

-(NSString*)confirmationTitle
{
	if(_confirmationTitle != nil)
		return _confirmationTitle;
	else if(_attributedConfirmationTitle != nil)
		return _attributedConfirmationTitle.string;
	else
		return nil;
}

-(void)setAttributedConfirmationTitle:(NSAttributedString *)attributedConfirmationTitle
{
	_attributedConfirmationTitle = [attributedConfirmationTitle copy];
	_confirmationTitle = nil;
	[self updateTitle];
}

-(NSAttributedString*)attributedConfirmationTitle
{
	if(_attributedConfirmationTitle != nil)
		return _attributedConfirmationTitle.copy;
	else if(_confirmationTitle != nil)
		return [[NSAttributedString alloc] initWithString:_confirmationTitle];
	else
		return nil;
}

-(CGSize)sizeThatFits:(CGSize)size
{
	return [_button sizeThatFits:size];
}

-(CGSize)intrinsicContentSize
{
	return [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

-(void)updateTitle
{
	if(self.buttonState == AvePurchaseButtonStateConfirmation)
	{
		if(_attributedConfirmationTitle != nil)
			_button.attributedTitle = _attributedConfirmationTitle;
		else
			_button.title = _confirmationTitle;
	}
	else
	{
		if(_attributedNormalTitle != nil)
			_button.attributedTitle = _attributedNormalTitle;
		else
			_button.title = _normalTitle;
	}
	
	[self invalidateIntrinsicContentSize];
}

-(void)updateTintColors
{
	_button.tintColor = self.buttonState == AvePurchaseButtonStateConfirmation ? self.confirmationColor : self.normalColor;
	_activityIndicatorView.tintColor = self.buttonState == AvePurchaseButtonStateConfirmation ? self.confirmationColor : self.normalColor;
}

-(void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
	_button.highlighted = highlighted && self.buttonState != AvePurchaseButtonStateProgress;
}

-(UIFont *)titleLabelFont
{
    return _button.titleLabel.font;
}

-(void)setTitleLabelFont:(UIFont *)font
{
    _button.titleLabel.font = font;
    [self invalidateIntrinsicContentSize];
}

@end
