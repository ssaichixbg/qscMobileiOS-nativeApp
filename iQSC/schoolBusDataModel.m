//
//  schoolBusDataModel.m
//  iQSC
//
//  Created by zy on 13-2-3.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "schoolBusDataModel.h"
//车号，起点，终点，发车时间，到站时间，运行时间，停靠地点，备注
@implementation schoolBusDataModel
@synthesize bz,ch,dzsj,fcsj,qd,yxsj,zd,tkdd;
-(NSDictionary *)returnDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self) {
        [dic setValue:self.ch forKey:@"车号"];
        [dic setValue:[NSNumber numberWithInt:self.qd ]forKey:@"起点"];
        [dic setValue:[NSNumber numberWithInt:self.zd ] forKey:@"终点"];
        [dic setValue:self.fcsj forKey:@"发车时间"];
        [dic setValue:self.dzsj forKey:@"到站时间"];
        [dic setValue:self.yxsj forKey:@"运行时间"];
        [dic setValue:self.tkdd forKey:@"停靠地点"];
        [dic setValue:self.bz forKey:@"备注"];
    }
    return dic;
}
-(schoolBusDataModel *)initWithLocalJson:(NSDictionary *)json{
    if (self = [super init]) {
        self.ch = [json objectForKey:@"车号"];
        self.qd = (enum schoolCampus)[(NSNumber *)[json objectForKey:@"起点"] intValue];
        self.zd = (enum schoolCampus)[(NSNumber *)[json objectForKey:@"终点"] intValue];
        self.fcsj = [json objectForKey:@"发车时间"];
        self.dzsj = [json objectForKey:@"到站时间"];
        self.yxsj = [json objectForKey:@"运行时间"];
        self.tkdd = [json objectForKey:@"停靠地点"];
        self.bz = [json objectForKey:@"备注"];
    }
    return self;
}
-(schoolBusDataModel *)initWithWebJson:(NSDictionary *)json{
    if (self = [super init]) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"H:mm";
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CCT"];

        self.ch = [json objectForKey:@"车号"];
        self.qd = [self campusWithString:[json objectForKey:@"起点"]];
        self.zd = [self campusWithString:[json objectForKey:@"终点"]];
        self.fcsj = [formatter dateFromString:[json objectForKey:@"发车时间"]];
        self.dzsj = [formatter dateFromString:[json objectForKey:@"到站时间"]];
        self.yxsj = [json objectForKey:@"运行时间"];
        self.tkdd = [json objectForKey:@"停靠地点"];
        self.bz = [json objectForKey:@"备注"];
    }
    return self;
}
-(enum schoolCampus)campusWithString:(NSString *)campusStr{
    if ([campusStr isEqualToString:@"紫金港校区"]) {
        return ZiJinGangCampus;
    }
    if ([campusStr isEqualToString:@"玉泉校区"]) {
        return YuQuanCampus;
    }
    if ([campusStr isEqualToString:@"西溪校区"]) {
        return XiXICampus;
    }
    if ([campusStr isEqualToString:@"之江校区"]) {
        return ZhiJiangCampus;
    }
    if ([campusStr isEqualToString:@"华家池校区"]) {
        return HuaJiaChiCampus;
    }
    return -1;
}
@end
