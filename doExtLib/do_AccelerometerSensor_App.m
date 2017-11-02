//
//  do_AccelerometerSensor_App.m
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_AccelerometerSensor_App.h"
static do_AccelerometerSensor_App* instance;
@implementation do_AccelerometerSensor_App
@synthesize OpenURLScheme;
+(id) Instance
{
    if(instance==nil)
        instance = [[do_AccelerometerSensor_App alloc]init];
    return instance;
}
@end
