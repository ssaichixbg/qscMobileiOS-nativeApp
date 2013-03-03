//
//  zjuXuehaoDataModel.h
//  iQSC
//
//  Created by zy on 13-1-29.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zjuXuehaoDataModel : NSObject{
    int xsid;
    NSString *stuid,*passwordm,*token,*real_name,*lei,*xi,*xzb;
    NSDate *birthday;
}
@property int xsid;
@property(nonatomic,copy) NSString *stuid;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *token;
@property(nonatomic,copy) NSString *real_name;
@property(nonatomic,copy) NSString *xzb;
@property(nonatomic,copy) NSString *lei;
@property(nonatomic,copy) NSString *xi;
@property(nonatomic,copy) NSDate *birthday;
-(NSString *)getid;
-(NSDictionary *)returnDic;
-(zjuXuehaoDataModel *)initWithLocalJson:(NSDictionary *)json;
-(void)addInfoWithWebJson:(NSDictionary *)json;
@end
