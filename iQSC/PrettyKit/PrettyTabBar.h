//
//  PrettyTabBar.h
//  PrettyExample
//
//  Created by Víctor on 01/03/12.

// Copyright (c) 2012 Victor Pena Placer (@vicpenap)
// http://www.victorpena.es/
// 
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
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

/** `PrettyTabBar` is a subclass of `UITabBar` that removes the
 glossy effect and lets you customize its colors.
 
 ![](../docs/Screenshots/tabbar.png)
 
 You can change the tab bar appearance as follows:
 
 - gradient start color
 - gradient end color
 - separator line volor

 */
@interface PrettyTabBar : UITabBar

/** Specifies the gradient's start color.
 
 By default is a black tone. */
@property (nonatomic) UIColor *gradientStartColor;

/** Specifies the gradient's end color.
 
 By default is a black tone. */
@property (nonatomic) UIColor *gradientEndColor;

/** Specifies the top separator's color.
 
 By default is a black tone. */
@property (nonatomic) UIColor *separatorLineColor;

@end
