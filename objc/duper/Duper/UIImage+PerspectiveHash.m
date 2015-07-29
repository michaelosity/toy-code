//
//  UIImage+PerspectiveHash.m
//  Duper
//
//  Created by Michael Wells on 1/22/15.
//  Copyright (c) 2015 jamfoundry. All rights reserved.
//

#import "UIImage+PerspectiveHash.h"

@implementation UIImage (PerspectiveHash)

// this is a very simple implementation of an average image hash. it
// resizes the image to 8x8 (which retains the structure of the image
// while throwing away the high-frequency details), converts the image
// to grescale (again color is a high-frequency detail), and then sets
// the nth bit if the corresponding b&w color value is greater than the
// mean color. it should be a very fast algorithm.
- (unsigned long long)computePerspectiveHash
{
    CGSize size = CGSizeMake(8, 8);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeLuminosity alpha:1.0f];
    
    uint8_t *data = CGBitmapContextGetData(ctx);
    
    float meanColor = 0.0f;
    for (int n = 0; n < 64; n++)
    {
        meanColor += data[n * 3] / 64.0f; // in grescale so all rgb should be the same
    }
    
    unsigned long long hash = 0;
    
    for (int n = 0; n < 64; n++)
    {
        if (data[n * 3] >= meanColor)
        {
            hash = hash | 1L << n;
        }
    }
    
    UIGraphicsEndImageContext();
    
    return hash;
}


+ (unsigned int)comparePerspectiveHashes:(unsigned long long)hash1 hash2:(unsigned long long)hash2
{
    unsigned long long n = hash1 ^ hash2;
    
    unsigned int count = 0;
    while (n > 0)
    {
        if (n & 1L)
        {
            count++;
        }
        n = n >> 1;
    }
    
    return count;
}

@end
