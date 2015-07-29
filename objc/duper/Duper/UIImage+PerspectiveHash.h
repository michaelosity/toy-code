//
//  UIImage+PerspectiveHash.h
//  Duper
//
//  Created by Michael Wells on 1/22/15.
//  Copyright (c) 2015 jamfoundry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PerspectiveHash)

- (unsigned long long) computePerspectiveHash;
+ (unsigned int) comparePerspectiveHashes:(unsigned long long)hash1 hash2:(unsigned long long)hash2;

@end
