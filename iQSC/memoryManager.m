//
//  memoryManager.m
//  iQSC
//
//  Created by zy on 13-2-4.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "memoryManager.h"

@implementation memoryManager
- (void)listen{
    while (1) {
        sleep(2);
        NSLog(@"the used memory:%.2f",[self usedMemory]);
    }
    
}
// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}
@end
