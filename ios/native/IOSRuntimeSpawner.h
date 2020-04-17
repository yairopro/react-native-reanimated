//
//  IOSRuntimeSpawner.h
//  RNReanimated
//
//  Created by Karol Bisztyga on 4/16/20.
//

#ifndef IOSRuntimeSpawner_h
#define IOSRuntimeSpawner_h

#include "RuntimeSpawner.h"
#import <jsi/JSCRuntime.h>

class IOSRuntimeSpawner : public RuntimeSpawner {
public:
    std::unique_ptr<jsi::Runtime> generateRuntimeSpec() override;
};

#endif /* IOSRuntimeSpawner_h */
