//
//  classTableController.h
//  iQSC
//
//  Created by zy on 13-1-20.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "coreUserHeader.h"
#import "coreSystemHeader.h"
#import "corePublicHeader.h"
#import "classTableDataModel.h"
#import "dateTypeDataModel.h"

@interface classTableController : NSObject{
    
}
-(classTableController *)initWithDefaultUser;
-(classTableController *)initWithDefaultUserOutline;
-(enum userAvailable)getState;
-(BOOL)freshFromServer;
-(void)freshCache;
-(NSArray *)getClassTable;
-(NSArray *)getClassTable:(NSDate *)date;
-(NSArray *)getClassTable:(NSString *)weekDay type:(dateTypeDataModel *)type;
-(NSArray *)getWeekClassTables;//start from Monday to Sunday
-(NSArray *)getWeekClassTables:(dateTypeDataModel *)type;
@end
