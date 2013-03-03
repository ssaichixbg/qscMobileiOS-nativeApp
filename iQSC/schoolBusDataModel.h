//
//  schoolBusDataModel.h
//  iQSC
//
//  Created by zy on 13-2-3.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>
//车号，起点，终点，发车时间，到站时间，运行时间，停靠地点，备注
@interface schoolBusDataModel : NSObject{
    NSString *ch,*yxsj,*bz,*tkdd;
    NSDate *fcsj,*dzsj;
    enum schoolCampus {
        ZiJinGangCampus,
        YuQuanCampus,
        XiXICampus,
        ZhiJiangCampus,
        HuaJiaChiCampus
    }qd,zd;
}
@property(nonatomic,copy) NSString *ch;
@property(nonatomic,copy) NSString *yxsj;
@property(nonatomic,copy) NSString *bz;
@property(nonatomic,copy) NSString *tkdd;
@property(nonatomic,copy) NSDate *fcsj;
@property(nonatomic,copy) NSDate *dzsj;
@property(nonatomic) enum  schoolCampus qd;
@property(nonatomic) enum  schoolCampus zd;

-(NSDictionary *)returnDic;
-(schoolBusDataModel *)initWithLocalJson:(NSDictionary *)json;
-(schoolBusDataModel *)initWithWebJson:(NSDictionary *)json;
-(enum schoolCampus)campusWithString:(NSString *)campusStr;

@end
