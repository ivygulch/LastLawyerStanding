//
//  UIToolbar+IVGUtils.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 6/12/11.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//

#import "UIToolbar+IVGUtils.h"

@implementation UIToolbar(IVGUtils)

- (void) adjustTitleLabel:(UILabel *) titleLabel {
    CGFloat inset = titleLabel.tag;
    CGSize tbSz = self.bounds.size;
    titleLabel.frame = (CGRect) {{inset,0},{tbSz.width-inset*2,tbSz.height}};
}

- (UILabel *) newTitleLabel:(NSString *) text 
                   withFont:(UIFont *) font 
                 widthInset:(CGFloat) inset
                  textColor:(UIColor *) textColor
                shadowColor:(UIColor *) shadowColor {
    UILabel *result = [[UILabel alloc] init];
    result.font = font;
    result.backgroundColor = [UIColor clearColor];
    result.textColor = textColor;
    result.shadowColor = shadowColor;
    result.textAlignment = NSTextAlignmentCenter;
    result.userInteractionEnabled = NO;
    result.adjustsFontSizeToFitWidth = YES;
    result.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    result.clipsToBounds = YES;
    result.tag = (int) inset; // store width inset in tag
    [self addSubview:result];
    [self adjustTitleLabel:result];
    result.text = text;
    return result;
}

@end
