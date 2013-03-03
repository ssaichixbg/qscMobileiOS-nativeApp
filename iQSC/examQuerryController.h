//
//  examQuerryController.h
//  iQSC
//
//  Created by zy on 13-1-29.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "coreUserHeader.h"
#import "examsDataModel.h"
#import "coreSystemHeader.h"


@interface examQuerryController : NSObject
-(examQuerryController *)initWithDefaultUser;
-(examQuerryController *)initWithDefaultUserOutline;
-(enum userAvailable)getState;
-(BOOL)freshFromServer;
-(NSArray *)getExamLists;
-(examsDataModel *)getExamByTime:(NSDate *)time;
@end
