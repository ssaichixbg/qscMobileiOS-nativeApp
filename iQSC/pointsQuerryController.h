//
//  pointsQuerryController.h
//  iQSC
//
//  Created by zy on 13-1-20.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pointsDataModel.h"
#import "coreUserHeader.h"
#import "coreSystemHeader.h"

@interface pointsQuerryController : NSObject
-(pointsQuerryController *)initWithDefaultUser;
-(pointsQuerryController *)initWithDefaultUserOutline;
-(enum userAvailable)getState;
-(BOOL)freshFromServer;
-(NSArray *)getGPALists;
-(NSArray *)getSingleCourseLists;
@end

