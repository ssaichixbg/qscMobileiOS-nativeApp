//
//  mainHeader.h
//  iQSC
//
//  Created by zy on 13-1-30.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#ifndef iQSC_mainHeader_h
#define iQSC_mainHeader_h

#import "MobileProbe.h"
#import "versionControl.h"
#import <Parse/Parse.h>
#import "Reachability.h"

#define reachable [[Reachability reachabilityWithHostname:@"m.myqsc.com"] currentReachabilityStatus]
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define APPSTORE_ID @"583334920"

#endif