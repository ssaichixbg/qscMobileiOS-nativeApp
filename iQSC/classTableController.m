//
//  classTableController.m
//  iQSC
//
//  Created by zy on 13-1-20.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "classTableController.h"

@implementation classTableController{
    qscApi *_qscRequest;//api请求实例
    zjuXuehaoDataModel *_currentUser;//当前用户
    NSArray *_cache;//缓存
}
-(classTableController *)initWithDefaultUser{
    if (self = [super init]){
        _currentUser = [[[zjuXuehaoController alloc] init] getMainUser];
        _qscRequest = [[qscApi alloc]initUserApi:_currentUser];
        _cache = nil;
    }
    return self;

}
-(classTableController *)initWithDefaultUserOutline{
    if (self = [super init]){
        _currentUser = [[[zjuXuehaoController alloc] init] getMainUser];
        _qscRequest = nil;
        _cache = nil;
    }
    return self;
}
-(enum userAvailable)getState{
    if (_qscRequest) {
        return [_qscRequest userState];
    }
    else{
        return UNEXIST;
    }

}
-(void)freshCache{
    _cache = nil;
    _cache = [[plistController new] loadPlistFileToArr:[NSString stringWithFormat:KEBIAO_PLIST,_currentUser.stuid]];
}
-(BOOL)freshFromServer{
    if ([self getState] == CORRECT) {
        _cache = [_qscRequest getKebiao];
        return [[plistController new] savePlistFile:_cache arrayName:[NSString stringWithFormat:KEBIAO_PLIST,_currentUser.stuid]];
    }
    else return NO;
}
-(NSArray *)getClassTable{
    return [self getClassTable:[NSDate date]];//now
}
-(NSArray *)getClassTable:(NSString *)weekDay type:(dateTypeDataModel *)type{
    NSMutableArray *coursesArr = [NSMutableArray array];// new array
    if (type.periodType == summerVacation || type.periodType == winterVacation) return coursesArr;
    if(!_cache) _cache = [[plistController new] loadPlistFileToArr:[NSString stringWithFormat:KEBIAO_PLIST,_currentUser.stuid]];
        
    if (type.isOdd) {
        for (NSDictionary *row in _cache) {
            NSArray *classesArr = [row valueForKey:@"class"];
            if ([classesArr isKindOfClass:[NSArray class]] && [classesArr count]> 0) {
                for (NSDictionary *classDic in classesArr) {
                    NSString *weekStr = [classDic valueForKey:@"week"];
                    NSString *weekdayStr = [classDic valueForKey:@"weekday"];
                    NSArray *classTimeArr = [classDic valueForKey:@"class"];
                    NSString *termStr = [row valueForKey:@"semester"];
                    
                    NSMutableDictionary *newrow = nil;
                    NSString *term = nil;
                    switch (type.periodType) {
                        case springTerm:
                            term = @"春";
                            break;
                        case summerTerm:
                            term = @"夏";
                            break;
                        case autumnTerm:
                            term = @"秋";
                            break;
                        case winterTerm:
                            term = @"冬";
                            break;
                        default:
                            break;
                    }
                    
                    if ([weekStr isKindOfClass:[NSString class] ] &&
                        ([weekStr isEqualToString:@"odd"] || [weekStr isEqualToString:@"both"]) &&
                        [weekDay isKindOfClass:[NSString class]] &&
                        [weekDay isEqualToString:weekdayStr] &&
                        [termStr isKindOfClass:[NSString class]] &&
                        [termStr rangeOfString:term].length > 0 ){//match the date given
                        
                        newrow = [NSMutableDictionary dictionaryWithDictionary:row];
                        [newrow setValue:[NSArray arrayWithArray:classTimeArr] forKey:@"current_time"];
                        [newrow setValue:[NSString stringWithFormat:@"%@",[classDic valueForKey:@"place"]] forKey:@"place"];
                        [newrow removeObjectForKey:@"class"];
                        //NSLog(@"%@ %@ %@",[newrow objectForKey:@"name"],weekdayStr,weekStr);
                        [coursesArr addObject:newrow];
                        
                    }
                    weekdayStr = nil;
                    weekStr = nil;
                    classTimeArr = nil;
                    
                }
                
            }
        }
    }
    else{
        for (NSDictionary *row in _cache) {
            NSArray *classesArr = [row valueForKey:@"class"];
            if ([classesArr isKindOfClass:[NSArray class]] && [classesArr count]> 0) {
                for (NSDictionary *classDic in classesArr) {
                    NSString *weekStr = [classDic valueForKey:@"week"];
                    NSString *weekdayStr = [classDic valueForKey:@"weekday"];
                    NSArray *classTimeArr = [classDic valueForKey:@"class"];
                    
                    NSString *termStr = [row valueForKey:@"semester"];
                    
                    NSMutableDictionary *newrow = nil;
                    NSString *term = nil;
                    switch (type.periodType) {
                        case springTerm:
                            term = @"春";
                            break;
                        case summerTerm:
                            term = @"夏";
                            break;
                        case autumnTerm:
                            term = @"秋";
                            break;
                        case winterTerm:
                            term = @"冬";
                            break;
                        default:
                            break;
                    }

                    if ([weekStr isKindOfClass:[NSString class] ] &&
                        ([weekStr isEqualToString:@"even"] || [weekStr isEqualToString:@"both"]) &&
                        [weekDay isKindOfClass:[NSString class]] &&
                        [weekDay isEqualToString:weekdayStr] &&
                        [termStr isKindOfClass:[NSString class]] &&
                        [termStr rangeOfString:term].length > 0 ) {//match the date given
                        
                        newrow = [NSMutableDictionary dictionaryWithDictionary:row];
                        [newrow setValue:[NSArray arrayWithArray:classTimeArr] forKey:@"current_time"];
                        [newrow setValue:[NSString stringWithFormat:@"%@",[classDic valueForKey:@"place"]] forKey:@"place"];
                        [newrow removeObjectForKey:@"class"];
                        //NSLog(@"%@ %@ %@",[newrow objectForKey:@"name"],weekdayStr,[classDic valueForKey:@"place"]);
                        [coursesArr addObject:newrow];
                        
                    }
                    weekdayStr = nil;
                    weekStr = nil;
                    classTimeArr = nil;
                    
                }
                
            }
        }
        
    }
    return coursesArr;

}
-(NSArray *)getClassTable:(NSDate *)date{
    dateTypeDataModel *type = [[publicInfoController new] getDateType:date];
    // get the number of day in a week
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"e";
    f.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CCT"];
    NSInteger weekDayNo = [[f stringFromDate:[NSDate date]] integerValue];
    f = nil;
    
    weekDayNo = (weekDayNo-1) == 0 ? 7: (weekDayNo -1);//Mon. is the 1st day
    NSString *weekDay = [NSString stringWithFormat:@"%d",weekDayNo];
    
    return [self getClassTable:weekDay type:type];
}
-(NSArray *)getWeekClassTables{
    dateTypeDataModel *type = [[publicInfoController new] getDateType:[NSDate date]];
    //type.isOdd = YES;
    //type.periodType = winterTerm;
    return [self getWeekClassTables:type];
}
-(NSArray *)getWeekClassTables:(dateTypeDataModel *)type{
    NSMutableArray *weekCourses = [NSMutableArray array];
    if ((type.periodType == summerVacation) || (type.periodType == winterVacation)) return weekCourses;
    
    for (int i = 1 ;i <= 7  ; i++) {
        [weekCourses addObject:[self getClassTable:[NSString stringWithFormat:@"%d",i] type:type]];
    }
    return weekCourses;
}
-(NSArray *)getOddWeekClassTables{
    NSDate *day = [NSDate date];
    dateTypeDataModel *type = [[publicInfoController new] getDateType:day];
    
    if (!type.isOdd) {
        day =[NSDate dateWithTimeIntervalSinceNow:3600*24*7];
        type = [[publicInfoController new] getDateType:day];
        if (!type.isOdd) {
            day =[NSDate dateWithTimeIntervalSinceNow:-3600*24*7];
        }
    }
    
    NSMutableArray *weekCourses = [NSMutableArray array];
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"e";
    f.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CCT"];
    NSInteger weekDay = [[f stringFromDate:day] integerValue];
    weekDay = (weekDay-1) == 0 ? 7: (weekDay -1);
    for (int i = 1 ;i <= 7  ; i++) {
        [weekCourses addObject:[self getClassTable:[NSDate dateWithTimeIntervalSinceNow:3600*24*(i - weekDay)]]];
    }
    return weekCourses;
}
-(NSArray *)getEvenWeekClassTables{
    NSDate *day = [NSDate date];
    dateTypeDataModel *type = [[publicInfoController new] getDateType:day];
    
    if (type.isOdd) {
        day =[NSDate dateWithTimeIntervalSinceNow:3600*24*7];
        type = [[publicInfoController new] getDateType:day];
        if (type.isOdd) {
            day =[NSDate dateWithTimeIntervalSinceNow:-3600*24*7];
        }
    }
    
    NSMutableArray *weekCourses = [NSMutableArray array];
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"e";
    f.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CCT"];
    NSInteger weekDay = [[f stringFromDate:day] integerValue];
    weekDay = (weekDay-1) == 0 ? 7: (weekDay -1);
    for (int i = 1 ;i <= 7  ; i++) {
        [weekCourses addObject:[self getClassTable:[NSDate dateWithTimeIntervalSinceNow:3600*24*(i - weekDay)]]];
    }
    return weekCourses;
}
@end
