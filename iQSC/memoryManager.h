//
//  memoryManager.h
//  iQSC
//
//  Created by zy on 13-2-4.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/sysctl.h>
#import <mach/mach.h>

@interface memoryManager : NSObject
- (double)usedMemory;
- (void)listen;
@end
