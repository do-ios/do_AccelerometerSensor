//
//  do_AccelerometerSensor_SM.m
//  DoExt_API
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_AccelerometerSensor_SM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import <CoreMotion/CoreMotion.h>
#import "doServiceContainer.h"
#import "doILogEngine.h"

@interface do_AccelerometerSensor_SM ()
{
    CMMotionManager *cmManager;
    doInvokeResult *invokeResult;
    NSMutableDictionary *node;
}

@end

@implementation do_AccelerometerSensor_SM
- (instancetype)init
{
    if (self = [super init]) {
        cmManager = [[CMMotionManager alloc]init];
        cmManager.accelerometerUpdateInterval = 0.1f;
        node = [NSMutableDictionary dictionary];
        invokeResult = [[doInvokeResult alloc]init];
    }
    return self;
}
#pragma mark - 方法
#pragma mark - 同步异步方法的实现

- (void)getAccelerometerData:(NSArray *)parms
{
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];

    if (cmManager.isDeviceMotionAvailable) {
        if (node) {
            [_invokeResult SetResultNode:node];
        }
    }else
        [[doServiceContainer Instance].LogEngine WriteError:nil :@"传感器不可用"];
}
- (void)start:(NSArray *)parms
{
    if (!cmManager.accelerometerAvailable) {
        [[doServiceContainer Instance].LogEngine WriteError:nil :@"传感器不可用"];
        return;
    }
    [cmManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        CMAccelerometerData *accelData = cmManager.accelerometerData;
        double x = accelData.acceleration.x;
        double y = accelData.acceleration.y;
        double z = accelData.acceleration.z;
        
        if (fabs(x)>2.0 ||fabs(y)>2.0 ||fabs(z)>2.0) {
            [self.EventCenter FireEvent:@"shake" :invokeResult];
        }
        [node setObject:@(x) forKey:@"x"];
        [node setObject:@(y) forKey:@"y"];
        [node setObject:@(z) forKey:@"z"];
        [invokeResult SetResultNode:node];
        [self.EventCenter FireEvent:@"change" :invokeResult];
    }];
}
- (void)stop:(NSArray *)parms
{
    [cmManager stopAccelerometerUpdates];
}
@end