//
//  examsDataModel.m
//  iQSC
//
//  Created by zy on 13-1-30.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "examsDataModel.h"

@implementation examsDataModel
@synthesize xkkh,kcmc,xf,cxbj,xm,xq,kssj,ksdd,kszwh,course_id_md5,time;
-(NSDictionary *)returnDic{
    if (xkkh) {
        return [NSDictionary dictionaryWithObjectsAndKeys:
                self.xkkh,@"选课课号",
                self.kcmc , @"课程名称",
                self.xf , @"学分",
                self.cxbj , @"重修标记",
                self.xm , @"姓名",
                self.xq , @"学期",
                self.kssj , @"考试时间",
                self.ksdd , @"考试地点",
                self.kszwh , @"考试座位号",
                self.course_id_md5 , @"course_id_md5",
                self.time , @"time",
                nil];
    }
    else return nil;
}
-(examsDataModel *)initWithJson:(NSDictionary *)json{
    if ((self = [super init]) || json){
        self.xkkh = [json valueForKey:@"选课课号"];
        self.kcmc = [json valueForKey:@"课程名称"];
        self.xf = [json valueForKey:@"学分"];
        self.cxbj = [json valueForKey:@"重修标记"];
        self.xm = [json valueForKey:@"姓名"];
        self.xq = [json valueForKey:@"学期"];
        self.kssj = [json valueForKey:@"考试时间"];
        self.ksdd = [json valueForKey:@"考试地点"];
        self.kszwh = [json valueForKey:@"考试座位号"];
        self.course_id_md5 = [json valueForKey:@"course_id_md5"];
        if ([[json valueForKey:@"time"] isKindOfClass:[NSDate class]]) {
            self.time = [json valueForKey:@"time"];
        }
        else{
            self.time = nil;
        }
    }
    return self;
}
-(NSDate *)transToNSDate:(NSString *)dateStr{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"yyyy年MM月dd日(HH:mm";
    f.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CCT"];//beijing time zone
    if (dateStr && [dateStr length] >0) {
        if ([dateStr length] >18) dateStr = [dateStr substringToIndex:17];
        return [f dateFromString:dateStr];
    }
    return nil;
}
@end
