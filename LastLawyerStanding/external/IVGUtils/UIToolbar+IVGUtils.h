//
//  UIToolbar+IVGUtils.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 6/12/11.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToolbar(IVGUtils)

- (void) adjustTitleLabel:(UILabel *) titleLabel;
- (UILabel *) newTitleLabel:(NSString *) text 
                   withFont:(UIFont *) font 
                 widthInset:(CGFloat) inset
                  textColor:(UIColor *) textColor
                shadowColor:(UIColor *) shadowColor;

@end
