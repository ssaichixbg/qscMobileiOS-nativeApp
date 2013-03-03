//
//  publicInfoController.m
//  iQSC
//
//  Created by zy on 13-2-3.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "publicInfoController.h"

@implementation publicInfoController{
    qscApi *_qscRequest;
}
-(BOOL)freshFromServer{
    if ([self freshFromServer:FRESH_SCHOOL_DATE] && [self freshFromServer:FRESH_XIAOCHE] && [self freshFromServer:FRESH_XIAOLI]) {
        return YES;
    }
    else{
        return NO;
    }
}
-(BOOL)freshFromServer:(NSInteger)type{
    if (!_qscRequest) {
        _qscRequest = [[qscApi alloc] initPublicApi];
    }
    NSArray *arrFromServer = nil;
    NSMutableArray *arrToSave = nil;
    switch (type) {
        case FRESH_SCHOOL_DATE:
            return [[plistController new]savePlistFile:[_qscRequest getSchoolDateInfo] dicName:SCHOOL_DATE_PLIST];
            break;
        case FRESH_XIAOCHE:
            arrFromServer = [_qscRequest getXiaoche];
            arrToSave = [NSMutableArray array];
            for (NSDictionary *row in arrFromServer) {
                [arrToSave addObject:[[[schoolBusDataModel alloc] initWithWebJson:row] returnDic]];
            }
            return [[plistController new] savePlistFile:arrToSave arrayName:XIAOCHE_PLIST];
            break;
        case FRESH_XIAOLI:
            arrFromServer = [_qscRequest getXiaoli];
            arrToSave = [NSMutableArray array];
            for (NSDictionary *row in arrFromServer) {
                [arrToSave addObject:[[[schoolScheduleDataModel alloc] initWithWebJson:row] returnDic]];
            }
            return [[plistController new] savePlistFile:arrToSave arrayName:XIAOLI_PLIST];
            break;
        default:
            return NO;
            break;
    }
}
-(NSArray *)getSchoolBusListFrom:(enum schoolCampus)start to:(enum schoolCampus)end{
    NSMutableArray *newArr = [NSMutableArray array];
    for (NSDictionary *row in [[plistController new] loadPlistFileToArr:XIAOCHE_PLIST]) {
        schoolBusDataModel *rowModel = [[schoolBusDataModel alloc] initWithLocalJson:row];
        if (rowModel.qd == start && rowModel.zd == end) {
            [newArr addObject:[NSDictionary dictionaryWithDictionary:row]];
        }
    }
    return newArr;
}
-(NSDictionary *)getSchoolScheduleList{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *vacationArr = [NSMutableArray array],*importantEventArr = [NSMutableArray array],*examArr = [NSMutableArray array];
    for (NSDictionary *row in [[plistController new] loadPlistFileToArr:XIAOLI_PLIST]) {
        schoolScheduleDataModel *rowModel = [[schoolScheduleDataModel alloc] initWithLocalJson:row];
        switch (rowModel.xiaoliType) {
            case importantEventType:
                [importantEventArr addObject:row];
                break;
            case examType:
                [examArr addObject:row];
                break;
            case vacationType:
                [vacationArr addObject:row];
            break;
            default:
                break;
        }
    }
    [dic setValue:vacationArr forKey:[NSString stringWithFormat:@"%d",vacationType]];
    [dic setValue:examArr forKey:[NSString stringWithFormat:@"%d",examType]];
    [dic setValue:importantEventArr forKey:[NSString stringWithFormat:@"%d",importantEventType]];
    
    return dic;
}
-(dateTypeDataModel *)getDateType{
    return [self getDateType:[NSDate date]];
}
-(dateTypeDataModel *)getDateType:(NSDate *)date{
    dateTypeDataModel *dateType = [dateTypeDataModel new];
    
    NSDateFormatter *f = [NSDateFormatter new];
    f.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CCT"];
    f.dateFormat = @"ww";
    int weekNumber = [[f stringFromDate:date] intValue];
    
    NSDictionary *localDic = [[plistController new] loadPlistFileToDic:SCHOOL_DATE_PLIST];
    if (!localDic) {
        [self freshFromServer:FRESH_SCHOOL_DATE];
        localDic = [[plistController new] loadPlistFileToDic:SCHOOL_DATE_PLIST];
    }
    
    dateType.isOdd = dateType.periodType = 0;
    for (NSNumber *row in [localDic valueForKey:@"oddWeekArray"]) {
        if (weekNumber == [row intValue]) {
            dateType.isOdd = YES;
            break;
        }
    }
    
    for (NSNumber *row in [localDic valueForKey:@"evenWeekArray"]) {
        if (weekNumber == [row intValue]) {
            dateType.isOdd = NO;
            break;
        }
    }

    for (NSNumber *row in [localDic valueForKey:@"chun"]) {
        if (weekNumber == [row intValue]) {
            dateType.periodType = springTerm;
            break;
        }
    }
    for (NSNumber *row in [localDic valueForKey:@"xia"]) {
        if (weekNumber == [row intValue]) {
            dateType.periodType = summerTerm;
            break;
        }
    }
    for (NSNumber *row in [localDic valueForKey:@"qiu"]) {
        if (weekNumber == [row intValue]) {
            dateType.periodType = autumnTerm;
            break;
        }
    }
    for (NSNumber *row in [localDic valueForKey:@"dong"]) {
        if (weekNumber == [row intValue]) {
            dateType.periodType = winterTerm;
            break;
        }
    }
    for (NSNumber *row in [localDic valueForKey:@"hanjia"]) {
        if (weekNumber == [row intValue]) {
            dateType.periodType = springTerm;
            break;
        }
    }
    for (NSNumber *row in [localDic valueForKey:@"shujia"]) {
        if (weekNumber == [row intValue]) {
            dateType.periodType = springTerm;
            break;
        }
    }
    return dateType;
}
@end
