//
//  karmaTests.m
//  karmaTests
//
//  Created by Michael Wells on 7/30/15.
//  Copyright (c) 2015 Michaelosity. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "MLYString.h"

@interface StringTests_rle : XCTestCase

@end

@implementation StringTests_rle

- (void)setUp {
    
    [super setUp];
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testNilString {

    // Given nil, we should return nil
    XCTAssertNil([MLYString rle:nil]);
}

- (void)testEmptyString {
    
    // Given empty string, we should return same thing
    XCTAssertTrue([[MLYString rle:@""] isEqualToString:@""]);
}

- (void)testCompressableStringPositive {

    // A string that compresses to somethign useful
    XCTAssertTrue([[MLYString rle:@"aaabbbccc"] isEqualToString:@"a3b3c3"]);
}

- (void)testCompressableStringNegative {
    
    // Negative test
    XCTAssertFalse([[MLYString rle:@"aaabbbcc"] isEqualToString:@"a3b3c3"]);
}

- (void)testSmallestStringReturned {
    
    // Should return the shortest string from compressed or original
    XCTAssertTrue([[MLYString rle:@"abcdeef"] isEqualToString:@"abcdeef"]);
}

@end
