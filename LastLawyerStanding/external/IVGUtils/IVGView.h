//
//  IVGView.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 12/5/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IVGView : UIView

@property (nonatomic,assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor *borderColor UI_APPEARANCE_SELECTOR;

@end
