//
//  MLYString.m
//  karma
//
//  Created by Michael Wells on 7/30/15.
//  Copyright (c) 2015 Michaelosity. All rights reserved.
//

#import "MLYString.h"

@implementation MLYString

// Given a string of lowercase letters write a function that run length encodes the string. If
// the "compressed" string is larger than the original, return the original string instead.

+ (NSString *)rle:(NSString *)s {
    
    if (! s) {
        return nil;
    }
    
    NSMutableString *rle = [[NSMutableString alloc] init];
    
    int n = 0;
    
    while (n < [s length]) {
        
        unichar c = [s characterAtIndex:n];
        
        int next = n + 1;
        while (next < [s length] && c == [s characterAtIndex:next]) {
            next = next + 1;
        }
        
        if (next - n == 1) {
            [rle appendFormat:@"%c", c];
        } else {
            [rle appendFormat:@"%c%d", c, next - n];
        }
        
        n = next;
    }
    
    return [rle length] < [s length] ? rle : s;
}

@end
