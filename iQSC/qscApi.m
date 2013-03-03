//
//  qscApi.m
//  iQSC
//
//  Created by zy on 13-1-20.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "qscApi.h"

@implementation qscApi
//初始化“请求用户数据”类。参数1：用户信息
-(qscApi *)initUserApi:(zjuXuehaoDataModel *)zjuXuehao{
    if (self = [super init]){
        _currentUser = zjuXuehao;
        [self validUser];
    }
    return self;
}
//初始化“请求公共数据”类
-(qscApi *)initPublicApi{
    if (self = [super init]){
        _currentUser = nil;
        _currentUserAvailable = NO;
    }
    return self;
}
//对数据进行base64加密
-(NSString *)rsaBase64:(NSString *)str{
    return str;
}
//json to NSDictionary
-(NSDictionary *)jsonToDic:(NSData *)data{
    NSError *er = nil;
    NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&er];
    NSLog(@"%@",er);
    if (![dic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"error occures while transform NSData to NSDictionary");
        return nil;
    }
    return dic;
}
//json to NSArray
-(NSArray *)jsonToArr:(NSData *)data{
    NSError *er = nil;
    NSArray *arr = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&er];
    NSLog(@"%@",er);
    if (![arr isKindOfClass:[NSArray class]]) {
        NSLog(@"error occures while transform NSData to NSArray");
        return nil;
    }
    return arr;
}

//根据不同api请求返回不同URLRequest实例
-(NSMutableURLRequest *)setRequst:(NSInteger)api{
    NSString *urlStr;
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    switch (api) {
        case VALID_XUEHAO:
            urlStr = [NSString stringWithFormat:@"%@/jw/validate?stuid=%@&pwd=%@",SERVER_URL,_currentUser.stuid,_currentUser.password];
            break;
        case GET_KAOSHI:
            urlStr = [NSString stringWithFormat:@"%@/jw/kaoshi?stuid=%@&pwd=%@",SERVER_URL,_currentUser.stuid,_currentUser.password];
            break;
        case GET_KEBIAO:
            urlStr = [NSString stringWithFormat:@"%@/jw/kebiao?stuid=%@&pwd=%@",SERVER_URL,_currentUser.stuid,_currentUser.password];
            break;
        case GET_CHENGJI:
            urlStr = [NSString stringWithFormat:@"%@/jw/chengji?stuid=%@&pwd=%@",SERVER_URL,_currentUser.stuid,_currentUser.password];
            break;
        case GET_STU_INFO:
            urlStr = [NSString stringWithFormat:@"%@/jw/stuinfo?stuid=%@&pwd=%@",SERVER_URL,_currentUser.stuid,_currentUser.password];
            break;
        case GET_JW_HASH:
            urlStr = [NSString stringWithFormat:@"%@/jw/hash?stuid=%@&pwd=%@",SERVER_URL,_currentUser.stuid,_currentUser.password];
            break;
        case GET_XIAOCHE:
            urlStr = [NSString stringWithFormat:@"%@/share/xiaoche",SERVER_URL];
            break;
        case GET_XIAOLI:
            urlStr = [NSString stringWithFormat:@"%@/share/shijian",SERVER_URL];
            break;
        case GET_SCHOOL_DATE_INFO:
            urlStr = [NSString stringWithFormat:@"%@/share/xiaoli",SERVER_URL];
            break;
        default:
            break;
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIME_OUT];//time limit
    [request setURL:url];
    [request setValue:@"Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_2_1 like Mac OS X; zh-cn) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5" forHTTPHeaderField:@"Üser-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return request;
    
}
//验证用户可用性
-(void)validUser{
    NSURLResponse *response;
    NSError *er;
    NSData *resultData;
    NSLog(@"qscApi:valid user with server");
    resultData = [NSURLConnection sendSynchronousRequest:[self setRequst:VALID_XUEHAO] returningResponse:&response error:&er];
    if (resultData) {
        NSDictionary *resultDic = [self jsonToDic:resultData];
        if ([resultDic valueForKey:@"stuid"] && [[resultDic valueForKey:@"stuid"] length] > 0) {
            _currentUser.token = [resultDic valueForKey:@"token"];
            NSLog(@"qscApi:user is availale");
            _currentUserAvailable = CORRECT;
        }
        else if ([[resultDic valueForKey:@"msg"] isEqualToString:@"密码错误"]){
            NSLog(@"qscApi:incorrext password");
            _currentUserAvailable = PW_INCORRECT;
        }
        else if ([[resultDic valueForKey:@"msg"] isEqualToString:@"无效学号"]){
            NSLog(@"qscApi:the stuid doesn't exsit"); 
            _currentUserAvailable = UNEXIST;
        }
        else{
            NSLog(@"qscApi:unknown error:%@",er);
            _currentUserAvailable = ERROR;
        }
    }
    else{
        NSLog(@"qscApi:unknown error:%@",er);
        _currentUserAvailable = ERROR;
    }
}
//返回用户状态
-(enum userAvailable)userState{
    return _currentUserAvailable;
}
//发送“考试数据”api请求
-(NSMutableArray *)getKaoshi{
    NSMutableArray *resultArr = nil;
    
    if (_currentUserAvailable != CORRECT) return resultArr;
    
    NSURLResponse *response;
    NSError *er;
    NSData *resultData;
    NSLog(@"qscApi:get kaoshi infomation from server");
    resultData = [NSURLConnection sendSynchronousRequest:[self setRequst:GET_KAOSHI] returningResponse:&response error:&er];
    
    if (resultData) {
        resultArr = [NSMutableArray arrayWithArray:[self jsonToArr:resultData]];
    }
    return resultArr;
}
//发送“课表数据”api请求
-(NSMutableArray *)getKebiao{
     NSMutableArray *resultArr = nil;
    
    if (_currentUserAvailable != CORRECT) return resultArr;
    
    NSURLResponse *response;
    NSError *er;
    NSData *resultData;
    NSLog(@"qscApi:get kebiao infomation from server");
    resultData = [NSURLConnection sendSynchronousRequest:[self setRequst:GET_KEBIAO] returningResponse:&response error:&er];
   
    if (resultData) {
        resultArr = [NSMutableArray arrayWithArray:[self jsonToArr:resultData]];
    }
    return resultArr;
}
//发送“成绩数据”api请求
-(NSMutableDictionary *)getChengji{
    NSMutableDictionary *resultDic = nil;
    
    if (_currentUserAvailable != CORRECT) return resultDic;

    NSURLResponse *response;
    NSError *er;
    NSData *resultData;
    NSLog(@"qscApi:get chengji infomation from server");
    resultData = [NSURLConnection sendSynchronousRequest:[self setRequst:GET_CHENGJI] returningResponse:&response error:&er];
    if (resultData) {
        resultDic = [NSMutableDictionary dictionaryWithDictionary:[self jsonToDic:resultData]];
    }
    return resultDic;
}
//发送“学生信息”api请求
-(NSMutableDictionary *)getStuInfo{
    NSMutableDictionary *resultDic = nil;
    
    if (_currentUserAvailable != CORRECT) return resultDic;
    
    NSURLResponse *response;
    NSError *er;
    NSData *resultData;
    NSLog(@"qscApi:get student infomation from server");
    resultData = [NSURLConnection sendSynchronousRequest:[self setRequst:GET_STU_INFO] returningResponse:&response error:&er];
    if (resultData) {
        resultDic = [NSMutableDictionary dictionaryWithDictionary:[self jsonToDic:resultData]];
    }
    return resultDic;

}
//发送“校车数据”api请求
-(NSMutableArray *)getXiaoche{
    NSMutableArray *resultArr = nil;
    
    //if (_currentUserAvailable != CORRECT) return resultArr;
    
    NSURLResponse *response;
    NSError *er;
    NSData *resultData;
    NSLog(@"qscApi:get xiaoche infomation from server");
    resultData = [NSURLConnection sendSynchronousRequest:[self setRequst:GET_XIAOCHE] returningResponse:&response error:&er];
    
    if (resultData) {
        resultArr = [NSMutableArray arrayWithArray:[self jsonToArr:resultData]];
    }
    return resultArr;
}
//发送“校历数据”api请求
-(NSMutableArray *)getXiaoli{
    NSMutableArray *resultArr = nil;
    
    //if (_currentUserAvailable != CORRECT) return resultArr;
    
    NSURLResponse *response;
    NSError *er;
    NSData *resultData;
    NSLog(@"qscApi:get kebiao infomation from server");
    resultData = [NSURLConnection sendSynchronousRequest:[self setRequst:GET_XIAOLI] returningResponse:&response error:&er];
    
    if (resultData) {
        resultArr = [NSMutableArray arrayWithArray:[self jsonToArr:resultData]];
    }
    return resultArr;
}
//发送“单双周数据”api请求
-(NSMutableDictionary *)getSchoolDateInfo{
    NSMutableDictionary *resultDic = nil;
    
    //if (_currentUserAvailable != CORRECT) return resultDic;
    
    NSURLResponse *response;
    NSError *er;
    NSData *resultData;
    NSLog(@"qscApi:get school date infomation from server");
    resultData = [NSURLConnection sendSynchronousRequest:[self setRequst:GET_SCHOOL_DATE_INFO] returningResponse:&response error:&er];
    if (resultData) {
        resultDic = [NSMutableDictionary dictionaryWithDictionary:[self jsonToDic:resultData]];
    }
    return resultDic;
}
@end
