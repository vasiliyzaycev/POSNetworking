//
//  POSSchedulableObject.h
//  POSRx
//
//  Created by Pavel Osipov on 11.01.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "POSSchedulable.h"
#import "NSException+POSRx.h"

@interface POSScheduleProtectionOptions : NSObject

+ (instancetype)defaultOptionsForClass:(Class)aClass;
+ (instancetype)include:(RACSequence *)includes exclude:(RACSequence *)excludes;

- (instancetype)include:(RACSequence *)includes;
- (instancetype)exclude:(RACSequence *)excludes;

@end

@interface POSSchedulableObject : NSObject <POSSchedulable>

- (instancetype)initWithScheduler:(RACScheduler *)scheduler;
- (instancetype)initWithScheduler:(RACScheduler *)scheduler options:(POSScheduleProtectionOptions *)options;

+ (BOOL)protect:(id)object forScheduler:(RACScheduler *)scheduler;
+ (BOOL)protect:(id)object forScheduler:(RACScheduler *)scheduler options:(POSScheduleProtectionOptions *)options;

+ (RACSequence *)selectorsForClass:(Class)aClass;
+ (RACSequence *)selectorsForProtocol:(Protocol *)aProtocol;

@end

#define POSRX_DEADLYFY_SCHEDULABLE_INITIALIZERS \
    POSRX_DEADLY_INITIALIZER(initWithScheduler:(RACScheduler *)scheduler) \
    POSRX_DEADLY_INITIALIZER(initWithScheduler:(RACScheduler *)scheduler \
                                       options:(POSScheduleProtectionOptions *)options)