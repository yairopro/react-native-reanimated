//
//  TestTools.m
//  ReanimatedExampleTests
//
//  Created by Karol Bisztyga on 3/26/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jsi/JSCRuntime.h>
#include "TestTools.h"

std::shared_ptr<facebook::jsi::Runtime> TestTools::rt = nullptr;
std::shared_ptr<Scheduler> TestTools::scheduler = nullptr;
