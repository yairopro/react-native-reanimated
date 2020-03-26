//
//  WorkletRegistryTest.mm
//  ReanimatedExampleTests
//
//  Created by Karol Bisztyga on 3/25/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
#import <XCTest/XCTest.h>
#import <jsi/JSCRuntime.h>
#import "WorkletRegistry.h"
#include "../TestTools/TestTools.h"

@interface WorkletRegistryTest : XCTestCase
{
  std::shared_ptr<jsi::Runtime> rtt;
  std::unique_ptr<WorkletRegistry> wr;
  std::shared_ptr<jsi::Function> fun;
}
@end

@implementation WorkletRegistryTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  rtt = TestTools::getRuntime();
  wr.reset(new WorkletRegistry);
  auto funObj = TestTools::stringToFunction("function () {}");
  fun.reset(&funObj);
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  ;
  [super tearDown];
}

- (void)testRegister {
  wr->registerWorklet(0, fun);
  
  XCTAssert(wr->getWorkletMap().find(0) != wr->getWorkletMap().end(), @"item added properly");
  XCTAssert(wr->getWorkletMap().find(1) == wr->getWorkletMap().end(), @"not added item not found");
}

- (void)testUnregister {
  wr->registerWorklet(0, fun);
  wr->unregisterWorklet(0);
  
  XCTAssert(wr->getWorkletMap().find(0) == wr->getWorkletMap().end(), @"item removed properly");
  XCTAssert(wr->getWorkletMap().size() == 0, @"collection empty");
}

- (void)testGetWorklet {
  wr->registerWorklet(0, fun);
  
  std::shared_ptr<Worklet> wt = wr->getWorklet(0);
  XCTAssert(wt->workletId == 0, @"worklet id valid");
  XCTAssert(wt->body != nullptr, @"worklet id valid");
}

@end
