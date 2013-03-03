//
//  schoolScheduleDataModel.m
//  iQSC
//
//  Created by zy on 13-2-3.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "schoolScheduleDataModel.h"

@implementation schoolScheduleDataModel
@synthesize qssj,sjlx,sjnr,zzsj,endTime,startTime,xiaoliType;
//事件类型，事件内容，起始时间，终止时间
-(NSDictionary *)returnDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self) {
        [dic setValue:self.sjlx forKey:@"事件类型"];
        [dic setValue:self.sjnr forKey:@"事件内容"];
        [dic setValue:self.qssj forKey:@"起始时间"];
        [dic setValue:self.zzsj forKey:@"终止时间"];
        [dic setValue:self.startTime forKey:@"start_time"];
        [dic setValue:self.endTime forKey:@"end_time"];
        [dic setValue:[NSNumber numberWithInt:self.xiaoliType] forKey:@"xiaoli_type"];
    }
    return dic;
}
-(schoolScheduleDataModel *)initWithLocalJson:(NSDictionary *)json{
    if (self = [super init]) {
        self.sjlx = [json valueForKey:@"事件类型"];
        self.sjnr = [json valueForKey:@"事件内容"];
        self.qssj = [json valueForKey:@"起始时间"];
        self.zzsj = [json valueForKey:@"终止时间"];
        self.startTime = [json valueForKey:@"start_time"];
        self.endTime = [json valueForKey:@"end_time"];
        self.xiaoliType = (enum xiaoliType)[(NSNumber *)[json valueForKey:@"xiaoli_type"] intValue];
    }
    return self;
}
-(schoolScheduleDataModel *)initWithWebJson:(NSDictionary *)json{
    if (self = [super init]) {
        self.sjlx = [json valueForKey:@"事件类型"];
        self.sjnr = [json valueForKey:@"事件内容"];
        self.qssj = [json valueForKey:@"起始时间"];
        self.zzsj = [json valueForKey:@"终止时间"];
        //transform date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMM dd y";
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CCT"];
        self.startTime = [formatter dateFromString:qssj];
        self.endTime = [formatter dateFromString:zzsj];
        
        //transform xiaoli type
        self.xiaoliType = [self typeWithString:self.sjlx];
    }
    return self;
}
-(enum xiaoliType)typeWithString:(NSString *)typeStr{
    if ([typeStr isEqualToString:@"考试"]) {
        return examType;
    }
    if ([typeStr isEqualToString:@"放假"]) {
        return vacationType;
    }
    if ([typeStr isEqualToString:@"重要事件"]) {
        return importantEventType;
    }
    return -1;
}
@end
