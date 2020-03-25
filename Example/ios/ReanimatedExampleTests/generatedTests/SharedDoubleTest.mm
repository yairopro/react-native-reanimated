//
//  SharedDoubleTest.mm
//
//  Created by Karol Bisztyga on 3/25/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
#import <XCTest/XCTest.h>
#import "SharedDouble.h"

@interface SharedDoubleTest : XCTestCase
@end

@implementation SharedDoubleTest

- (void)test {
  XCTAssert(1 == 1, @"testing SharedDouble");
}

@end
