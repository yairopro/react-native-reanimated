//
//  RuntimeSpawner.h
//  Pods
//
//  Created by Karol Bisztyga on 16/04/2020.
//

#ifndef REANIMATEDEXAMPLE_RUNTIME_SPAWNER_H
#define REANIMATEDEXAMPLE_RUNTIME_SPAWNER_H

#include <memory>
#include <jsi/jsi.h>

using namespace facebook;

class RuntimeSpawner {
public:
    /*static std::unique_ptr<jsi::Runtime> generateRuntime() {
        if (instance == nullptr) {
            throw std::runtime_error("no runtime spawner specified");
        }
        return instance->generateRuntimeSpec();
    };*/
    virtual std::unique_ptr<jsi::Runtime> generateRuntimeSpec() = 0;
private:
    //static std::unique_ptr<RuntimeSpawner> instance;
};

#endif /* REANIMATEDEXAMPLE_RUNTIME_SPAWNER_H */
