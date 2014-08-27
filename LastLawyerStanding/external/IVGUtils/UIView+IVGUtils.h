//
//  UIView+IVGUtils.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 3/23/11.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

enum UIViewVerticalAlignment
{
	UIViewVerticalAlignmentNone = 0,
    UIViewVerticalAlignmentTop,
    UIViewVerticalAlignmentCenter,
    UIViewVerticalAlignmentFull,
    UIViewVerticalAlignmentBottom
};
typedef enum UIViewVerticalAlignment UIViewVerticalAlignment;

enum UIViewHorizontalAlignment
{
	UIViewHorizontalAlignmentNone = 0,
    UIViewHorizontalAlignmentLeft,
    UIViewHorizontalAlignmentCenter,
    UIViewHorizontalAlignmentFull,
    UIViewHorizontalAlignmentRight
};
typedef enum UIViewHorizontalAlignment UIViewHorizontalAlignment;

@interface UIView(IVGUtils)

// needs to be a weak reference so we avoid a retain cycle between the view and it's controller/owner
@property (nonatomic,weak) id viewOwner;
@property (nonatomic,assign) CGPoint frameOrigin;
@property (nonatomic,assign) CGFloat frameX;
@property (nonatomic,assign) CGFloat frameY;
@property (nonatomic,assign) CGSize frameSize;
@property (nonatomic,assign) CGFloat frameWidth;
@property (nonatomic,assign) CGFloat frameHeight;

@property (nonatomic,assign) CGFloat frameLeft;
@property (nonatomic,assign) CGFloat frameRight;
@property (nonatomic,assign) CGFloat frameTop;
@property (nonatomic,assign) CGFloat frameBottom;

- (NSString *) superviewDescription;
- (id) findFirstViewInHierarchyWithKindOfClass: (Class) clazz;
- (void) logSizes:(NSString *) desc;
- (void) removeAllGestureRecognizers;
- (void) setOriginYBelow:(UIView *) baseView withGap:(CGFloat) gap;
- (CGFloat) bottom;
- (CGFloat) bottomOfLowestSubview;
- (CGFloat) topOfHighestSubview;
- (CGRect) absoluteFrame;
- (CGPoint) absoluteOrigin;
- (void) removeAllSubviews;

+ (void) updateFrame:(UIView *) view x:(CGFloat) x;
+ (void) updateFrame:(UIView *) view w:(CGFloat) w;
+ (CGFloat) bottomOfLowestView:(NSArray *) views;
+ (CGFloat) topOfHighestView:(NSArray *) views;
+ (id) findFirstViewInHiearchyWith:(id) item kindOfClass: (Class) clazz;

- (UIView *) findFirstResponder;
- (UIView *) findFirstResponderInView:(UIView*) view;

- (void) positionSubview:(UIView *) view horizontalAlignment:(UIViewHorizontalAlignment) horizontalAlignment verticalAlignment:(UIViewVerticalAlignment) verticalAlignment width:(CGFloat) width height:(CGFloat) height;
- (void) positionSubview:(UIView *) view horizontalAlignment:(UIViewHorizontalAlignment) horizontalAlignment verticalAlignment:(UIViewVerticalAlignment) verticalAlignment;

- (void) positionSubviewAtTop:(UIView *) view withHeight:(CGFloat) height;
- (void) positionSubviewAtBottom:(UIView *) view withHeight:(CGFloat) height;
- (void) positionSubviewAtLeft:(UIView *) view withWidth:(CGFloat) width;
- (void) positionSubviewAtRight:(UIView *) view withWidth:(CGFloat) width;

- (void) positionSubviewFull:(UIView *) view;

- (void) addSubview:(UIView *) view horizontalAlignment:(UIViewHorizontalAlignment) horizontalAlignment verticalAlignment:(UIViewVerticalAlignment) verticalAlignment width:(CGFloat) width height:(CGFloat) height;
- (void) addSubview:(UIView *) view horizontalAlignment:(UIViewHorizontalAlignment) horizontalAlignment verticalAlignment:(UIViewVerticalAlignment) verticalAlignment;

- (void) addSubviewToTop:(UIView *) view withHeight:(CGFloat) height;
- (void) addSubviewToBottom:(UIView *) view withHeight:(CGFloat) height;
- (void) addSubviewToLeft:(UIView *) view withWidth:(CGFloat) width;
- (void) addSubviewToRight:(UIView *) view withWidth:(CGFloat) width;

- (void) addSubviewFull:(UIView *) view;

- (NSString *) debugHierarchy:(CGPoint) pointToCheck;
- (NSString *) debugString;

- (UIImage *) captureContentAsImage;

@end
