//
//  UILabel+IVGUtils.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 09/01/11.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//  Derived from:
//    http://stackoverflow.com/questions/1054558/how-do-i-vertically-align-text-within-a-uilabel
//

#import <UIKit/UIKit.h>

@interface UILabel(IVGUtils)
- (void)alignTop;
- (void)alignBottom;
- (void)setText:(NSString *) text adjustHeightUsingLineBreakMode:(NSLineBreakMode) lineBreakMode;

@end
