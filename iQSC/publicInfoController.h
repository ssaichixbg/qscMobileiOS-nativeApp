//
//  publicInfoController.h
//  iQSC
//
//  Created by zy on 13-2-3.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "corePublicHeader.h"
#import "coreSystemHeader.h"
#import "schoolBusDataModel.h"
#import "schoolScheduleDataModel.h"
#import "dateTypeDataModel.h"

#define FRESH_XIAOCHE 100
#define FRESH_XIAOLI 101
#define FRESH_SCHOOL_DATE 102

@interface publicInfoController : NSObject
-(BOOL)freshFromServer;
-(BOOL)freshFromServer:(NSInteger)type;

-(NSArray *)getSchoolBusListFrom:(enum schoolCampus)start to:(enum schoolCampus)end;
//返回校历
//格式:｛dateType:[dateTypeDataModel的字典数组],｝
-(NSDictionary *)getSchoolScheduleList;

-(dateTypeDataModel *)getDateType;
-(dateTypeDataModel *)getDateType:(NSDate *)date;
@end
