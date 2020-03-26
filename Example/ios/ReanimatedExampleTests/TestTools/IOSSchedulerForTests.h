//
//  IOSSchedulerForTests.h
//  ReanimatedExampleTests
//
//  Created by Karol Bisztyga on 3/26/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#ifndef IOSSchedulerForTests_h
#define IOSSchedulerForTests_h


#include <stdio.h>
#include "Scheduler.h"
#import <React/RCTUIManager.h>

class IOSSchedulerForTests : public Scheduler {
  public:
  void scheduleOnUI(std::function<void()> job) override;
  void scheduleOnJS(std::function<void()> job) override;
  virtual ~IOSSchedulerForTests() {}
};

#endif /* IOSSchedulerForTests_h */
