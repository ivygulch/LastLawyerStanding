//
//  IVGGradientButton.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 4/17/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IVGGradientButton : UIButton

@property (nonatomic,strong) NSArray *colors UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) NSArray *highlightColors UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor *borderColor UI_APPEARANCE_SELECTOR;

@end
