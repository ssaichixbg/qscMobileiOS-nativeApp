//
//  zjuXuehaoDataModel.m
//  iQSC
//
//  Created by zy on 13-1-29.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "zjuXuehaoDataModel.h"

@implementation zjuXuehaoDataModel
@synthesize password,token,stuid,xsid,real_name,xi,lei,xzb,birthday;
//从本地json初始化数据模型
-(zjuXuehaoDataModel *)initWithLocalJson:(NSDictionary *)json{
    if (self = [super init]){
        self.xsid = [[json valueForKey:@"xsid"] integerValue];
        self.stuid = [json valueForKey:@"stuid"];
        self.password = [json valueForKey:@"password"];
       // self.token = [json valueForKey:@"token"];
        self.real_name = [json valueForKey:@"real_name"];
        self.xi = [json valueForKey:@"xi"];
        self.lei = [json valueForKey:@"lei"];
        self.xzb = [json valueForKey:@"xzb"];
        self.birthday = [json valueForKey:@"birthday"];
    }
    return self;
}
//从网络json初始化数据模型
- (void)addInfoWithWebJson:(NSDictionary *)json{
    self.xsid = [[self getid] integerValue];
    //self.stuid = [json valueForKey:@"stuid"];
    //self.password = [json valueForKey:@"password"];
    // self.token = [json valueForKey:@"token"];
    self.real_name = [json valueForKey:@"name"];
    self.xi = [json valueForKey:@"xi"];
    self.lei = [json valueForKey:@"lei"];
    self.xzb = [json valueForKey:@"xzb"];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"yyyyMMdd";
    f.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CCT"];//beijing time zone
    self.birthday = [f dateFromString:[json valueForKey:@"birthday"]];
    return;
}
//返回一个当前数据模型的字典副本
-(NSDictionary *)returnDic{
    if (stuid) {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSString stringWithFormat:@"%d",self.xsid],@"xsid",
            self.stuid,@"stuid",
            self.password,@"password",
            //self.token,@"token",
            self.real_name,@"real_name",
            self.xi,@"xi",
            self.xzb,@"xzb",
            self.lei,@"lei",
            self.birthday,@"biethday",
            nil];
    }
    else return nil;
}
//生成时间戳
-(NSString *)getid{
    //get system time
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddHHmmss"];
    return [[dateformatter stringFromDate:senddate] stringByAppendingFormat:@"%d",(arc4random() % 900)+100];
}
@end
