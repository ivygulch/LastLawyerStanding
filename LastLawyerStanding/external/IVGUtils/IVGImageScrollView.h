//
//  IVGImageScrollView.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 6/12/11.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kIVGImageScrollView_TapZoomStep 1.5f

@interface IVGImageScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;
@property (assign) NSUInteger index;
@property (nonatomic,assign, getter=isAutomaticMaximumScale) BOOL automaticMaximumScale;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,weak) IBOutlet id<UIScrollViewDelegate> secondaryDelegate;

- (void)setMaxMinZoomScalesForCurrentBounds;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;

@end
