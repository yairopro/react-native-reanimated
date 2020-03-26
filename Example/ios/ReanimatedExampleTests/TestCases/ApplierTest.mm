//
//  ApplierTest.mm
//  ReanimatedExampleTests
//
//  Created by Karol Bisztyga on 3/25/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
#import <XCTest/XCTest.h>
#include <string>
#include <memory>
#include <vector>
#include <tuple>
#import "Applier.h"
#include "../TestTools/TestTools.h"
#include "Worklet.h"
#include "ErrorHandler.h"
#import "IOSErrorHandler.h"
#include "IOSSchedulerForTests.h"
#include "SharedDouble.h"
#include "WorkletModule.h"

@interface ApplierTest : XCTestCase
{
  double initialSDValue;
  std::shared_ptr<SharedDouble> sd;
  std::shared_ptr<jsi::Runtime> rt;
}
@end

@implementation ApplierTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  initialSDValue = 27;
  sd.reset(new SharedDouble(0, initialSDValue));
  rt = TestTools::getRuntime();
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  ;
  [super tearDown];
}

- (std::tuple<std::shared_ptr<Applier>, std::shared_ptr<WorkletModule>>)createApplier:(const char *)functionStr {
  
  // create worklet
  std::shared_ptr<Worklet> worklet(new Worklet);
  worklet->workletId = 0;
  worklet->body = std::make_shared<jsi::Function>(TestTools::stringToFunction(functionStr));
  // get scheduler
  std::shared_ptr<Scheduler> scheduler(TestTools::getScheduler());
  // create error handler
  std::shared_ptr<ErrorHandler> errorHandler(((ErrorHandler*)new IOSErrorHandler(scheduler)));
  // create shared value registry
  std::shared_ptr<SharedValueRegistry> sharedValueRegistry(new SharedValueRegistry);
  // create shared values
  sharedValueRegistry->registerSharedValue(0, sd);
  // create applier
  std::shared_ptr<Applier> applier(new Applier(0, worklet, { 0 }, errorHandler, sharedValueRegistry));
  // create mapper registry
  std::shared_ptr<MapperRegistry> mapperRegistry(new MapperRegistry(sharedValueRegistry));
  // create applier registry
  std::shared_ptr<ApplierRegistry> applierRegistry(new ApplierRegistry(mapperRegistry));
  // create worklet registry
  std::shared_ptr<WorkletRegistry> workletRegistry(new WorkletRegistry);
  // create event value
  jsi::Value uv = jsi::Value::undefined();
  std::shared_ptr<jsi::Value> eventValue(&uv);
  // create worklet module
  std::shared_ptr<WorkletModule> workletModule(new WorkletModule(
                                        sharedValueRegistry,
                                        applierRegistry,
                                        workletRegistry,
                                        eventValue,
                                        errorHandler));
  return { applier, workletModule };
}

- (void)testApply {
  XCTAssert(sd->value == initialSDValue, @"shared value initialized properly");
  // elements:
  //  function string
  //  expexted return value
  //  new value of shared double expected
  std::vector<std::tuple<std::string, bool, double>> data = {
    { "function(v) {}", false, initialSDValue },
    { "function(v) {v.set(88.3);}", false, 88.3 },
    { "function(v) {v.set(45); return true;}", true, 45 },
    { "function(v) {v.set(0); if (v.value !== 0) { return true; }v.set(111);}", false, 111 },
  };
  
  for (auto item : data) {
    auto app = [self createApplier:std::get<0>(item).c_str()];
    XCTAssert(std::get<0>(app)->apply(*rt, std::get<1>(app)) == std::get<1>(item), @"applier returned proper value");
    XCTAssert(sd->value == std::get<2>(item), @"shared value changed properly");
  }
  
}

- (void)testOnFinishListeners {
  int counter = 0;
  
  auto app = [self createApplier:"function(){ return true; }"];
  std::get<0>(app)->addOnFinishListener([&counter]() -> void { counter += 1; });
  std::get<0>(app)->addOnFinishListener([&counter]() -> void { counter += 2; });
  XCTAssert(std::get<0>(app)->apply(*rt, std::get<1>(app)), @"applier returned proper value");
  
  auto app2 = [self createApplier:"function(){}"];
  std::get<0>(app2)->addOnFinishListener([&counter]() -> void { counter += 4; });
  XCTAssert(!std::get<0>(app2)->apply(*rt, std::get<1>(app2)), @"applier returned proper value");
  
  XCTAssert(counter == 3, @"valid number of finish listener calls");
}

@end
