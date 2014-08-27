//
//  IVGTextView.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 12/6/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGTextView.h"
#import "NSArray+IVGUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "UIDevice+IVGUtils.h"

#define DEFAULT_PLACEHOLDER_COLOR [UIColor colorWithWhite:0.702f alpha:1.0f]

@interface IVGTextView()
@property (nonatomic,assign) BOOL shouldDrawPlaceholder;
@end

@implementation IVGTextView

#pragma mark Life cycle events

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self configureView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self configureView];
    }
    return self;
}

- (void) awakeFromNib;
{
    [super awakeFromNib];
    [self configureView];
}

- (void) configureView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];

    self.layer.cornerRadius = 8.0;
    self.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    self.layer.borderWidth = 2.0;
    self.shouldDrawPlaceholder = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

#pragma Overridden methods

- (void) setText:(NSString *) text {
    [super setText:text];
    [self updateShouldDrawPlaceholder];
}

- (void) setPlaceholder:(NSString *) placeholder {
    _placeholder = placeholder;
    [self updateShouldDrawPlaceholder];
}

- (void) setPlaceholderColor:(UIColor *)placeholderColor;
{
    _placeholderColor = placeholderColor;
    [self updateShouldDrawPlaceholder];
}

- (void) setPlaceholderFont:(UIFont *)placeholderFont;
{
    _placeholderFont = placeholderFont;
    [self updateShouldDrawPlaceholder];
}

- (NSString *) placeholderFontString;
{
    return (self.placeholderFont == nil) ? nil : [NSString stringWithFormat:@"%@ %f", self.placeholderFont.fontName, self.placeholderFont.pointSize];
}

- (void) setPlaceholderFontString:(NSString *)placeholderFontString;
{
    NSArray *components = [placeholderFontString componentsSeparatedByString:@" "];
    if ([components count] < 1) {
        self.placeholderFont = nil;
        return;
    }

    NSString *lastComponent = [components objectAtIndex:[components count]-1 outOfRange:nil];
    CGFloat pointSize = [lastComponent floatValue];
    NSString *fontName;
    if (pointSize > 0) {
        fontName = [placeholderFontString substringToIndex:[placeholderFontString length]-[lastComponent length]-1];
    } else {
        fontName = placeholderFontString;
        pointSize = self.font.pointSize;
    }

    UIFont *font;
    if ([fontName isEqualToString:@"System"])  {
        font = [UIFont systemFontOfSize:pointSize];
    } else if ([fontName isEqualToString:@"System Bold"])  {
        font = [UIFont boldSystemFontOfSize:pointSize];
    } else if ([fontName isEqualToString:@"System Italic"])  {
        font = [UIFont italicSystemFontOfSize:pointSize];
    } else {
        font = [UIFont fontWithName:fontName size:pointSize];
    }
    self.placeholderFont = font;
}


#pragma mark - Private

- (void) drawRect:(CGRect) rect {
    [super drawRect:rect];

    if (self.shouldDrawPlaceholder) {
        if (self.placeholderColor == nil) {
            [DEFAULT_PLACEHOLDER_COLOR set];
        } else {
            [self.placeholderColor set];
        }
        UIFont *useFont = (self.placeholderFont == nil) ? self.font : self.placeholderFont;
        if (RUNNING_ON_IOS7) {
            NSDictionary *attributes = @{NSFontAttributeName:useFont};
            [self.placeholder drawInRect:CGRectMake(8.0f, 8.0f, self.frame.size.width - 16.0f, self.frame.size.height - 16.0f) withAttributes:attributes];
        } else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            [self.placeholder drawInRect:CGRectMake(8.0f, 8.0f, self.frame.size.width - 16.0f, self.frame.size.height - 16.0f) withFont:useFont];
#pragma GCC diagnostic pop
        }
    }
}


- (void) updateShouldDrawPlaceholder {
    BOOL prev = self.shouldDrawPlaceholder;
    self.shouldDrawPlaceholder = (self.placeholder != nil) && (self.placeholderColor != nil) && (self.text.length == 0);

    if (prev != self.shouldDrawPlaceholder) {
        [self setNeedsDisplay];
    }
}

- (void) handleTextDidChangeNotification:(NSNotification *) notification {
    [self updateShouldDrawPlaceholder];
}

@end
