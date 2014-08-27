//
//  UIView+IVGCustomProperties.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 12/15/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IVGCustomProperties)

@property (nonatomic,assign) CGFloat backing_cornerRadius;
@property (nonatomic,assign) CGFloat backing_borderWidth;
@property (nonatomic,weak) UIColor *backing_borderColor;
@property (nonatomic,weak) NSArray *backing_colors;
@property (nonatomic,weak) NSArray *backing_highlightColors;

- (void) updateColors;

@end
