//
// AveBorderedButton.h
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

// defaults
extern CGFloat kAveBorderedButtonDefaultBorderWidth;
extern CGFloat kAveBorderedButtonDefaultCornerRadius;

/*!
 @abstract Button that has a border and fills itself on highlighting.
 
 Use the .title property to change the title of this button.
 */
IB_DESIGNABLE
@interface AveBorderedButton : UIControl

// title for this button - no differences between states
@property (nonatomic, copy) IBInspectable NSString* title;
@property (nonatomic, copy) IBInspectable NSAttributedString* attributedTitle;
@property (nonatomic, strong) IBInspectable UIImage* image;

// title properties
@property (nonatomic, readonly) UILabel* titleLabel; // don't set .text property directly, use .title
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;

// looks, animates when updated
@property (nonatomic, assign) IBInspectable CGFloat borderWidth; // defaults to kAveBorderedButtonDefaultBorderWidth (animatable)
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius; // defaults to kAveBorderedButtonDefaultCornerRadius (animatable)

@end
