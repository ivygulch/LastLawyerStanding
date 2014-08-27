//
//  UILabel+IVGUtils.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 09/01/11.
//  Copyright 2011 Ivy Gulch, LLC. All rights reserved.
//  Derived from:
//    http://stackoverflow.com/questions/1054558/how-do-i-vertically-align-text-within-a-uilabel
//

#import "UILabel+IVGUtils.h"
#import "UIDevice+IVGUtils.h"

@implementation UILabel(IVGUtils)

- (CGSize) calculateFontSize:(UIFont *) font;
{
    if (RUNNING_ON_IOS7) {
        NSDictionary *attributes = @{NSFontAttributeName:self.font};
        return [self.text sizeWithAttributes:attributes];
    } else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        return [self.text sizeWithFont:self.font];
#pragma GCC diagnostic pop
    }
}

- (CGSize) calculateConstrainedToSizeWithText:(NSString *) text font:(UIFont *) font size:(CGSize) size;
{
    if (RUNNING_ON_IOS7) {
        NSDictionary *attributes = @{NSFontAttributeName:self.font};
        CGRect rect = [text boundingRectWithSize:size
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:attributes
                                              context:nil];
        return rect.size;
    } else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        return [text sizeWithFont:self.font constrainedToSize:size lineBreakMode:self.lineBreakMode];
#pragma GCC diagnostic pop
    }
}

- (void)alignTop {
    CGSize fontSize = [self calculateFontSize:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self calculateConstrainedToSizeWithText:self.text font:self.font size:CGSizeMake(finalWidth, finalHeight)];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
}

- (void)alignBottom {
    CGSize fontSize = [self calculateFontSize:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self calculateConstrainedToSizeWithText:self.text font:self.font size:CGSizeMake(finalWidth, finalHeight)];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
}

- (void)setText:(NSString *) text adjustHeightUsingLineBreakMode:(NSLineBreakMode) lineBreakMode {
    // calculate new size, but all we really want is the height
    CGSize originalSize = self.bounds.size;
    CGSize newSize = [self calculateConstrainedToSizeWithText:text font:self.font size:originalSize];

    // reset the existing frame to newly calculated size and ask label to sizeToFit
    self.frame = (CGRect){self.frame.origin,{self.bounds.size.width,newSize.height}};
    self.numberOfLines = 0;
    self.lineBreakMode = lineBreakMode;
    self.text = text;
    [self sizeToFit];
    
    // sizeToFit will also change the width, change it back since if the label is used again
    // (like in a table view cell), the starting point for the next time will be wrong
    self.frame = (CGRect){self.frame.origin,{originalSize.width,self.bounds.size.height}};
}

@end
