//
//  IVGKeyboardToolbar.h
//  MyFactor
//
//  Created by Douglas Sjoquist on 12/22/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IVGKeyboardToolbar;

@protocol IVGKeyboardToolbarDelegate<NSObject>
@optional
- (void) keyboardToolbarWillShow:(IVGKeyboardToolbar *) keyboardToolbar;
- (void) keyboardToolbarDidShow:(IVGKeyboardToolbar *) keyboardToolbar;
- (void) keyboardToolbarWillHide:(IVGKeyboardToolbar *) keyboardToolbar;
- (void) keyboardToolbarDidHide:(IVGKeyboardToolbar *) keyboardToolbar;
- (void) keyboardToolbar:(IVGKeyboardToolbar *) keyboardToolbar didSelectPreviousActionFromFirstResponder:(UIView *) firstResponder;
- (void) keyboardToolbar:(IVGKeyboardToolbar *) keyboardToolbar didSelectNextActionFromFirstResponder:(UIView *) firstResponder;
- (void) keyboardToolbar:(IVGKeyboardToolbar *) keyboardToolbar didSelectDismissKeyboardActionFromFirstResponder:(UIView *) firstResponder;
@end

@interface IVGKeyboardToolbar : UIToolbar

@property (nonatomic,weak) IBOutlet UIBarButtonItem *previousBBI;
@property (nonatomic,weak) IBOutlet UIBarButtonItem *nextBBI;
@property (nonatomic,weak) IBOutlet UIBarButtonItem *dismissKeyboardBBI;

@property (nonatomic,weak) id<IVGKeyboardToolbarDelegate> keyboardToolbarDelegate;
@property (nonatomic,strong) UIView *siblingView;

@end
