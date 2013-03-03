//
//  schoolScheduleDataModel.h
//  iQSC
//
//  Created by zy on 13-2-3.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>
//事件类型，事件内容，起始时间，终止时间
@interface schoolScheduleDataModel : NSObject{
    NSString *sjlx,*sjnr,*qssj,*zzsj;
    NSDate *startTime,*endTime;
    enum xiaoliType{
        vacationType,
        examType,
        importantEventType
    }xiaoliType;
}
@property(nonatomic,copy) NSString *sjlx;
@property(nonatomic,copy) NSString *sjnr;
@property(nonatomic,copy) NSString *qssj;
@property(nonatomic,copy) NSString *zzsj;
@property(nonatomic,copy) NSDate *startTime;
@property(nonatomic,copy) NSDate *endTime;
@property(nonatomic) enum xiaoliType xiaoliType;

-(NSDictionary *)returnDic;
-(schoolScheduleDataModel *)initWithLocalJson:(NSDictionary *)json;
-(schoolScheduleDataModel *)initWithWebJson:(NSDictionary *)json;
-(enum xiaoliType)typeWithString:(NSString *)typeStr;
@end
