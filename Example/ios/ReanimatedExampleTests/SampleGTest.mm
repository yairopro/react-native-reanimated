//
//  SampleGTest.m
//  ReanimatedExampleTests
//
//  Created by Karol Bisztyga on 3/19/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
#import <Foundation/Foundation.h>
#include <gtest/gtest.h>
#import "SharedDouble.h"

TEST(Sample, Firstt) {
  SharedDouble sd(0, 5.7);
  EXPECT_EQ(0, sd.id);
  EXPECT_EQ(5.7, sd.value);
  sd.setNewValue(std::shared_ptr<SharedDouble>(new SharedDouble(1, 55.2)));
  EXPECT_EQ(55.2, sd.value);
}
