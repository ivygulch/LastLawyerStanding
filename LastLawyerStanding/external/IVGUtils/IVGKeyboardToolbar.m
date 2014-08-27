//
//  IVGKeyboardToolbar.m
//  MyFactor
//
//  Created by Douglas Sjoquist on 12/22/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGKeyboardToolbar.h"
#import "UIView+IVGUtils.h"

#define ANIMATION_DURATION 0.3

@interface IVGKeyboardToolbar()
@property (nonatomic,assign) CGRect originalToolbarFrame;
@property (nonatomic,strong) NSDictionary *siblingOriginalValues;
@end

@implementation IVGKeyboardToolbar

- (void) awakeFromNib;
{
    [super awakeFromNib];

    [self configureView];
}

- (void) configureView;
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    [self.previousBBI setTarget:self];
    [self.previousBBI setAction:@selector(previousBBIAction)];

    [self.nextBBI setTarget:self];
    [self.nextBBI setAction:@selector(nextBBIAction)];

    [self.dismissKeyboardBBI setTarget:self];
    [self.dismissKeyboardBBI setAction:@selector(dismissKeyboardBBIAction)];
}

- (void) dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) handleKeyboardWillShow:(NSNotification *)notification;
{
    self.autoresizingMask = UIViewAutoresizingNone;
    CGRect f = self.frame;
    f.origin.y = self.siblingView.superview.bounds.size.height;
    self.originalToolbarFrame = f;
    self.frame = self.originalToolbarFrame;
    [self.siblingView.superview addSubview:self]; // kluge to ensure it is attached at the correct level

    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

                         CGPoint tvAbsoluteOrigin = [self.superview absoluteOrigin];
                         CGRect toolbarFrame = self.originalToolbarFrame;
                         CGFloat toolbarHeight = toolbarFrame.size.height;
                         toolbarFrame.origin.y = keyboardFrame.origin.y - tvAbsoluteOrigin.y - toolbarHeight;
                         self.frame = toolbarFrame;

                         if ([self.siblingView isKindOfClass:[UITableView class]]) {
                             UITableView *tableView = (UITableView *) self.siblingView;
                             // keyboard already adjusted contentInset for tableView, we need to add keyboard height to that adjustment here
                             UIEdgeInsets originalInsets = [tableView contentInset];
                             self.siblingOriginalValues = @{@"originalInsets":[NSValue valueWithUIEdgeInsets:originalInsets]};

                             CGFloat toolbarHeight = self.bounds.size.height;
                             UIEdgeInsets insets = originalInsets;
                             insets.bottom += toolbarHeight;
                             [tableView setContentInset:insets];
                             [tableView setScrollIndicatorInsets:insets];
                         }

                         if ([self.keyboardToolbarDelegate respondsToSelector:@selector(keyboardToolbarWillShow:)]) {
                             [self.keyboardToolbarDelegate keyboardToolbarWillShow:self];
                         }
                     }];
}

- (void) handleKeyboardDidShow:(NSNotification *)notification;
{
    if ([self.keyboardToolbarDelegate respondsToSelector:@selector(keyboardToolbarDidShow:)]) {
        [self.keyboardToolbarDelegate keyboardToolbarDidShow:self];
    }
}

- (void) handleKeyboardWillHide:(NSNotification *)notification;
{
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         self.frame = self.originalToolbarFrame;
                         if ([self.siblingView isKindOfClass:[UITableView class]]) {
                             UITableView *tableView = (UITableView *) self.siblingView;
                             UIEdgeInsets originalInsets = [[self.siblingOriginalValues objectForKey:@"originalInsets"] UIEdgeInsetsValue];
                             [tableView setContentInset:originalInsets];
                             [tableView setScrollIndicatorInsets:originalInsets];
                         }
                         if ([self.keyboardToolbarDelegate respondsToSelector:@selector(keyboardToolbarWillHide:)]) {
                             [self.keyboardToolbarDelegate keyboardToolbarWillHide:self];
                         }
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void) handleKeyboardDidHide:(NSNotification *)notification;
{
    if ([self.keyboardToolbarDelegate respondsToSelector:@selector(keyboardToolbarDidHide:)]) {
        [self.keyboardToolbarDelegate keyboardToolbarDidHide:self];
    }
}

- (void) previousBBIAction;
{
    if ([self.keyboardToolbarDelegate respondsToSelector:@selector(keyboardToolbar:didSelectPreviousActionFromFirstResponder:)]) {
        [self.keyboardToolbarDelegate keyboardToolbar:self didSelectPreviousActionFromFirstResponder:[self.superview findFirstResponder]];
    }
}

- (void) nextBBIAction;
{
    if ([self.keyboardToolbarDelegate respondsToSelector:@selector(keyboardToolbar:didSelectNextActionFromFirstResponder:)]) {
        [self.keyboardToolbarDelegate keyboardToolbar:self didSelectNextActionFromFirstResponder:[self.superview findFirstResponder]];
    }
}

- (void) dismissKeyboardBBIAction;
{
    if ([self.keyboardToolbarDelegate respondsToSelector:@selector(keyboardToolbar:didSelectDismissKeyboardActionFromFirstResponder:)]) {
        [self.keyboardToolbarDelegate keyboardToolbar:self didSelectDismissKeyboardActionFromFirstResponder:[self.superview findFirstResponder]];
    }
}

@end
