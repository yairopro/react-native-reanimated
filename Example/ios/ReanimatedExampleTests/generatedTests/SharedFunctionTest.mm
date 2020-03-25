//
//  SharedFunctionTest.mm
//
//  Created by Karol Bisztyga on 3/25/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
#import <XCTest/XCTest.h>
#import "SharedFunction.h"

@interface SharedFunctionTest : XCTestCase
@end

@implementation SharedFunctionTest

- (void)test {
  XCTAssert(1 == 1, @"testing SharedFunction");
}

@end
