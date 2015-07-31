//
//  FunctionTests.m
//  karma
//
//  Created by Michael Wells on 7/30/15.
//  Copyright (c) 2015 Michaelosity. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "MLYFunction.h"

@interface FunctionTests : XCTestCase

@end

@implementation FunctionTests

- (void)setUp {
    
    [super setUp];
}

- (void)tearDown {

    [super tearDown];
}

- (void)testZero {

    XCTAssertEqual([MLYFunction fibonacci_1:0], 0);
    XCTAssertEqual([MLYFunction fibonacci_2:0], 0);
}

- (void)testOne {
    
    XCTAssertEqual([MLYFunction fibonacci_1:1], 1);
    XCTAssertEqual([MLYFunction fibonacci_2:1], 1);
}

- (void)testTwenty {
    
    XCTAssertEqual([MLYFunction fibonacci_1:20], 6765);
    XCTAssertEqual([MLYFunction fibonacci_2:20], 6765);
}

- (void)testSlow {
    
    [self measureBlock:^{
        [MLYFunction fibonacci_1:40];
    }];
}

- (void)testFast {
    
    [self measureBlock:^{
        [MLYFunction fibonacci_2:40];
    }];
}

@end
