//
//  IVGTouchableTableView.m
//  TRCShowLeads
//
//  Created by Douglas Sjoquist on 8/24/13.
//  Copyright (c) 2013 Technology Resource Corporation. All rights reserved.
//

#import "IVGTouchableTableView.h"

@implementation IVGTouchableTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void) awakeFromNib;
{
    [super awakeFromNib];
    [self setupView];
}

- (void) setupView;
{
    NSLog(@"setup IVGTouchableTableView");
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [super touchesBegan:touches withEvent:event];

    [[NSNotificationCenter defaultCenter] postNotificationName:kIVGTouchableTableViewNotification_touchesBegan object:self];
}


@end
