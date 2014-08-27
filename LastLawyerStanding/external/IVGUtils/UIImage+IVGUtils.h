//
//  UIImage+IVGUtils.h
//  IVGUtils
//
//  Created by Douglas Sjoquist on 3/12/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IVGUtils)

- (UIImage *) scaleToSize:(CGSize) size;
- (UIImage *) scale:(CGFloat) scale;
+ (UIImage *) imageNamed:(NSString *)name inDirectory:(NSString *) directory;

/* Following methods
 * Copyright (c) 2010 Olivier Halligon
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
*/
-(UIImage*)resizedImageToSize:(CGSize)dstSize;
-(UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;


@end
