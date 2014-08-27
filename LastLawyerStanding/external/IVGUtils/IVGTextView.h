//
//  IVGTextView.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 12/6/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IVGTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIFont *placeholderFont;
@property (nonatomic, weak) NSString *placeholderFontString;
@property (nonatomic, retain) UIColor *placeholderColor;

@end
