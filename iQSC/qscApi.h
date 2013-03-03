//
//  qscApi.h
//  iQSC
//
//  Created by zy on 13-1-20.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zjuXuehaoDataModel.h"

#define TIME_OUT 8.0f

#define VALID_XUEHAO 100
#define GET_KEBIAO 101
#define GET_KAOSHI 102
#define GET_CHENGJI 103
#define GET_STU_INFO 104
#define GET_JW_HASH 105

#define GET_XIAOCHE 200
#define GET_XIAOLI 201
#define GET_SCHOOL_DATE_INFO 202//获取单双周信息

#define SERVER_URL @"http://m.myqsc.com/dev"
@interface qscApi : NSObject{
    enum userAvailable{//用户状态
        CORRECT,//正确
        PW_INCORRECT,//密码错误
        UNEXIST,//学号错误
        ERROR//未知错误
    } _currentUserAvailable;
    zjuXuehaoDataModel *_currentUser;
}
-(qscApi *)initUserApi:(zjuXuehaoDataModel *)zjuXuehao;
-(qscApi *)initPublicApi;
-(NSMutableURLRequest *)setRequst:(NSInteger)api;
-(NSString *)rsaBase64:(NSString *)str;

-(NSDictionary *)jsonToDic:(NSData *)data;
-(NSArray *)jsonToArr:(NSData *)data;

-(void)validUser;
-(enum userAvailable)userState;

-(NSMutableArray *)getKaoshi;
-(NSMutableArray *)getKebiao;
-(NSMutableDictionary *)getChengji;
-(NSMutableDictionary *)getStuInfo;
-(NSMutableArray *)getXiaoche;
-(NSMutableArray *)getXiaoli;
-(NSMutableDictionary *)getSchoolDateInfo;
@end
