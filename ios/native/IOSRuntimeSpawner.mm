//
//  IOSRuntimeSpawner.m
//  RNReanimated
//
//  Created by Karol Bisztyga on 4/16/20.
//

#import <Foundation/Foundation.h>
#include "IOSRuntimeSpawner.h"
#include "Logger.h"

using namespace facebook;

std::unique_ptr<jsi::Runtime> IOSRuntimeSpawner::generateRuntimeSpec() {
    std::unique_ptr<jsi::Runtime> rt(static_cast<jsi::Runtime*>(facebook::jsc::makeJSCRuntime().release()));
    return std::move(rt);
}
