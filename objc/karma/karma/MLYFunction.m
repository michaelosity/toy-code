//
//  MLYFunctions.m
//  karma
//
//  Created by Michael Wells on 7/30/15.
//  Copyright (c) 2015 Michaelosity. All rights reserved.
//

#import "MLYFunction.h"

@implementation MLYFunction

#pragma mark - Fibonacci Numbers

// This is a canonical example of the fibonacci numbers implemented recursively. It is
// super simple, but really slow.
+(unsigned long)fibonacci_1:(unsigned long)n {
    if (n == 0) return 0;
    if (n == 1) return 1;
    return [self fibonacci_1:n - 2] + [self fibonacci_1:n - 1];
}

// A much more involved example where we "memoize" (or cache) the previously computed
// values. The old rule, if it's costly to compute cache it.
+(unsigned long)fibonacci_2:(unsigned long)n {
    
    if (n == 0) return 0;
    if (n == 1) return 1;
    
    static NSMutableDictionary *cache;
    if (! cache) {
        cache = [[NSMutableDictionary alloc] init];
    }
    
    NSNumber *key = [NSNumber numberWithLongLong:n];
    
    NSNumber *fc = cache[key];
    if (fc) {
        return [fc longLongValue];
    }
    
    unsigned long long f = [self fibonacci_2:n - 2] + [self fibonacci_2:n - 1];
    
    cache[key] = [NSNumber numberWithLongLong:f];
    
    return f;
}

@end
