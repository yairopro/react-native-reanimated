//
//  TestTools.h
//  ReanimatedExampleTests
//
//  Created by Karol Bisztyga on 3/26/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#ifndef TestTools_h
#define TestTools_h

#include <string>
#include <vector>
#include <jsi/JSCRuntime.h>
#include "IOSSchedulerForTests.h"
#include "Applier.h"
#include "Worklet.h"
#include "ErrorHandler.h"
#include "IOSErrorHandler.h"
#include "SharedValue.h"
#include "WorkletModule.h"

using namespace facebook;

class TestTools {
  static std::shared_ptr<jsi::Runtime> rt;
  static std::shared_ptr<Scheduler> scheduler;
public:
  static jsi::Function stringToFunction(std::string str) {
    std::string wrappedStr = "(" + str + ")";
    return (getRuntime()->global().getPropertyAsFunction(*getRuntime(), "eval").call(*getRuntime(), wrappedStr.c_str())).getObject(*getRuntime()).getFunction(*getRuntime());
  }
  
  static std::shared_ptr<jsi::Runtime> getRuntime() {
    if (rt == nullptr) {
      rt.reset(static_cast<jsi::Runtime*>(facebook::jsc::makeJSCRuntime().release()));
    }
    return rt;
  }
  
  static std::shared_ptr<Scheduler> getScheduler() {
    if (scheduler == nullptr) {
      scheduler.reset(new IOSSchedulerForTests);
    }
    return scheduler;
  }

  static std::shared_ptr<ErrorHandler> mockErrorHanlder() {
    std::shared_ptr<Scheduler> scheduler = TestTools::getScheduler();
    return std::shared_ptr<ErrorHandler>(((ErrorHandler*)new IOSErrorHandler(scheduler)));
  }

  static std::shared_ptr<SharedValueRegistry> mockSharedValueRegistry() {
    return std::shared_ptr<SharedValueRegistry>(new SharedValueRegistry);
  }

  static std::shared_ptr<Worklet> mockWorklet(std::string functionStr) {
    std::shared_ptr<Worklet> worklet(new Worklet);
    worklet->workletId = 0;
    worklet->body = std::make_shared<jsi::Function>(TestTools::stringToFunction(functionStr));
    return worklet;
  }

  static std::shared_ptr<Applier> mockApplier(
      std::string functionStr,
      std::shared_ptr<SharedValueRegistry> sharedValueRegistry,
      std::vector<int> sharedValueIds) {
    return std::shared_ptr<Applier>(new Applier(
        0,
        TestTools::mockWorklet(functionStr),
        sharedValueIds,
        TestTools::mockErrorHanlder(),
        sharedValueRegistry));
  }

  static std::shared_ptr<MapperRegistry> mockMapperRegistry(std::shared_ptr<SharedValueRegistry> sharedValueRegistry=nullptr) {
    std::shared_ptr<SharedValueRegistry> svr = sharedValueRegistry;
    if (svr == nullptr) {
      svr = TestTools::mockSharedValueRegistry();
    }
    return std::shared_ptr<MapperRegistry>(new MapperRegistry(svr));
  }

  static std::shared_ptr<ApplierRegistry> mockApplierRegistry(std::shared_ptr<MapperRegistry> mapperRegistry) {
    return std::shared_ptr<ApplierRegistry>(new ApplierRegistry(mapperRegistry));
  }

  static std::shared_ptr<ApplierRegistry> mockApplierRegistry(std::shared_ptr<SharedValueRegistry> sharedValueRegistry=nullptr) {
    std::shared_ptr<SharedValueRegistry> svr = sharedValueRegistry;
    if (svr == nullptr) {
      svr = TestTools::mockSharedValueRegistry();
    }
    return std::shared_ptr<ApplierRegistry>(new ApplierRegistry(TestTools::mockMapperRegistry(svr)));
  }

  static std::shared_ptr<WorkletRegistry> mockWorkletRegistry() {
    return std::shared_ptr<WorkletRegistry>(new WorkletRegistry);
  }

  static std::shared_ptr<WorkletModule> mockWorkletModule(std::shared_ptr<SharedValueRegistry> sharedValueRegistry) {
    return std::shared_ptr<WorkletModule>(new WorkletModule(
        sharedValueRegistry,
        TestTools::mockApplierRegistry(sharedValueRegistry),
        TestTools::mockWorkletRegistry(),
        std::shared_ptr<jsi::Value>(new jsi::Value),
        TestTools::mockErrorHanlder()
    ));
  }
};

#endif /* TestTools_h */
