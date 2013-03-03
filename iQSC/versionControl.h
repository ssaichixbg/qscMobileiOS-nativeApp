//
//  versionControll.h
//  iQSC
//
//  Created by zy on 12-12-16.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "coreUserHeader.h"
#import "corePublicHeader.h"
#import "coreSystemHeader.h"


@interface versionControl : NSObject{
    
}
-(void)firstLauch;
-(BOOL)checkNewVersion;
-(void)updateAllData;
-(void)updateSystemData;
-(void)updateUserData;
@end
