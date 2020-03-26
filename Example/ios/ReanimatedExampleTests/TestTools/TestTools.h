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
#import <jsi/JSCRuntime.h>
#include "IOSSchedulerForTests.h"

using namespace facebook;

class TestTools {
  static std::shared_ptr<jsi::Runtime> rt;
  static std::shared_ptr<Scheduler> scheduler;
public:
  static jsi::Function stringToFunction(const char* str) {
    std::string wrappedStr = "(";
    wrappedStr += str;
    wrappedStr += ")";
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
};

#endif /* TestTools_h */
