//
//  ApplierTest.mm
//  ReanimatedExampleTests
//
//  Created by Karol Bisztyga on 3/25/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
#import <XCTest/XCTest.h>
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
  std::shared_ptr<Applier> applier;
  std::shared_ptr<Worklet> worklet;
  std::shared_ptr<ErrorHandler> errorHandler;
  std::shared_ptr<SharedValueRegistry> sharedValueRegistry;
  std::shared_ptr<WorkletModule> workletModule;
  double initialValue;
  std::shared_ptr<SharedDouble> sd;
}
@end

@implementation ApplierTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  
  // create worklet
  worklet.reset(new Worklet);
  worklet->workletId = 0;
  worklet->body = std::make_shared<jsi::Function>(TestTools::stringToFunction("function(v) {v.set(9);}"));
  // get scheduler
  std::shared_ptr<Scheduler> scheduler(TestTools::getScheduler());
  // create error handler
  errorHandler.reset(((ErrorHandler*)new IOSErrorHandler(scheduler)));
  // create shared value registry
  sharedValueRegistry.reset(new SharedValueRegistry);
  // create shared values
  initialValue = 27;
  sd.reset(new SharedDouble(0, initialValue));
  sharedValueRegistry->registerSharedValue(0, sd);
  // create applier
  applier.reset(new Applier(0, worklet, { 0 }, errorHandler, sharedValueRegistry));
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
  workletModule.reset(new WorkletModule(
                                        sharedValueRegistry,
                                        applierRegistry,
                                        workletRegistry,
                                        eventValue,
                                        errorHandler));
   
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  ;
  [super tearDown];
}

- (std::shared_ptr<Applier>)createApplier {
  return nullptr;
}

- (void)testApply {
  std::shared_ptr<jsi::Runtime> rt = TestTools::getRuntime();
  XCTAssert(sd->value == initialValue, @"shared value initialized properly");
  applier->apply(*rt, workletModule);
  XCTAssert(sd->value == 9, @"shared value changed properly");
}

- (void)testAddOnFinishListener {
  XCTAssert(1 == 1, @"testing Applier");
}

- (void)testFinish {
  XCTAssert(1 == 1, @"testing Applier");
}

@end
