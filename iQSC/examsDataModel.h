//
//  examsDataModel.h
//  iQSC
//
//  Created by zy on 13-1-30.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface examsDataModel : NSObject{
    NSString *xkkh,*kcmc,*xf,*cxbj,*xm,*xq,*kssj,*ksdd,*kszwh,*course_id_md5;
    NSDate *time;
}
//选课课号，课程名称，学分，重修标记，姓名，学期，考试时间，考试地点，考试座位号，课程MD5
@property(nonatomic,copy) NSString *xkkh;
@property(nonatomic,copy) NSString *kcmc;
@property(nonatomic,copy) NSString *xf;
@property(nonatomic,copy) NSString *cxbj;
@property(nonatomic,copy) NSString *xm;
@property(nonatomic,copy) NSString *xq;
@property(nonatomic,copy) NSString *kssj;
@property(nonatomic,copy) NSString *ksdd;
@property(nonatomic,copy) NSString *kszwh;
@property(nonatomic,copy) NSString *course_id_md5;
@property(nonatomic,copy) NSDate *time;

-(NSDictionary *)returnDic;
-(examsDataModel *)initWithJson:(NSDictionary *)json;
-(NSDate *)transToNSDate:(NSString *)dateStr;
@end
