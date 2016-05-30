//
//  AvePurchaseButton.h
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

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AvePurchaseButtonState)
{
	AvePurchaseButtonStateNormal,		// normal, colored button
	AvePurchaseButtonStateConfirmation,	// confirmation button, using the confirmationTitle/Color
	AvePurchaseButtonStateProgress,		// progress indicator state
};

/**
 @abstract A button which toggles between different states
 */
IB_DESIGNABLE
@interface AvePurchaseButton : UIControl

@property (nonatomic, assign) IBInspectable AvePurchaseButtonState buttonState;
-(void)setButtonState:(AvePurchaseButtonState)buttonState animated:(BOOL)animated;

@property (nonatomic, strong) IBInspectable UIImage* image;

//Button font
@property (nonatomic, strong) IBInspectable UIFont* titleLabelFont;

// normal state colors
@property (nonatomic, copy) IBInspectable NSString* normalTitle;
@property (nonatomic, copy) IBInspectable NSAttributedString* attributedNormalTitle;
@property (nonatomic, retain) IBInspectable UIColor* normalColor; // needed, equals tintColor

// confirmation state colors
@property (nonatomic, copy) IBInspectable NSString* confirmationTitle;
@property (nonatomic, copy) IBInspectable NSAttributedString* attributedConfirmationTitle;
@property (nonatomic, retain) IBInspectable UIColor* confirmationColor;

@end
