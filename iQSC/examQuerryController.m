//
//  examQuerryController.m
//  iQSC
//
//  Created by zy on 13-1-29.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "examQuerryController.h"

@implementation examQuerryController{
    qscApi *_qscRequest;//api请求实例
    zjuXuehaoDataModel *_currentUser;//当前用户
    NSMutableArray *_cache;//缓存（用于重复获取列表）
}

//使用默认用户初始化实例（需连接）
-(examQuerryController *)initWithDefaultUser{
    if (self = [super init]){
        _currentUser = [[[zjuXuehaoController alloc] init] getMainUser];
        _qscRequest = [[qscApi alloc]initUserApi:_currentUser];
        _cache = nil;
    }
    return self;
}
//脱机使用默认用户初始化实例
-(examQuerryController *)initWithDefaultUserOutline{
    if (self = [super init]){
        _currentUser = [[[zjuXuehaoController alloc] init] getMainUser];
        _qscRequest = nil;
        _cache = nil;
    }
    return self;
}
//获取用户可用性状态
-(enum userAvailable)getState{
    if (_qscRequest) {
        return [_qscRequest userState];
    }
    else{
        return UNEXIST;
    }
    
}
//从服务器更新（覆盖更新）
-(BOOL)freshFromServer{
    if (!_qscRequest) _qscRequest = [[qscApi alloc]initUserApi:_currentUser];
    if ([self getState] == CORRECT) {
        NSLog(@"examQuerry:request data from server");
        NSArray *examsRequestArr = [_qscRequest getKaoshi];//exam data from server
        if ([examsRequestArr count] < 1) return NO;
        
        
        NSMutableArray *examsArr = [NSMutableArray array];
        
        for (NSDictionary *examDic in examsRequestArr) {
            NSDate *timeNew = [[[examsDataModel alloc] init] transToNSDate:[examDic objectForKey:@"考试时间"]];
            NSMutableDictionary *examNew = [NSMutableDictionary dictionaryWithDictionary:examDic];
            [examNew setValue:timeNew forKey:@"time"];
            
            BOOL add = YES;
            if ([[examNew objectForKey:@"考试时间"] length] < 10 || ![timeNew isKindOfClass:[NSDate class]] || [timeNew compare:[NSDate date]] == NSOrderedAscending ){
                add = NO;
            }//judge time
            if (add) {
                [examsArr addObject:examNew];//porcessed exam data
            }
        }
        _cache = [NSArray arrayWithArray:examsArr];
        return [[plistController new] savePlistFile:examsArr arrayName:[NSString stringWithFormat:KAOSHI_PLIST,_currentUser.stuid]];
    }
    else{
        return NO;
    }
}
//从本地获取考试列表
-(NSArray *)getExamLists{
    NSLog(@"examQuerry:load local exam list");
    NSString *fileName = [NSString stringWithFormat:KAOSHI_PLIST,_currentUser.stuid];
    if (!_cache) {
        _cache = [[plistController new] loadPlistFileToArr:fileName];
    }
    return _cache ;//local data
}
//根据时间获取考试
-(examsDataModel *)getExamByTime:(NSDate *)time{
    NSArray *examsArr = [self getExamLists];
    NSDate * timeLocal = nil;
    for (NSDictionary *examLocalDic in examsArr) {
        timeLocal = [examLocalDic objectForKey:@"考试时间"];
        if ([timeLocal compare:time] == NSOrderedSame) {
            return [[examsDataModel alloc] initWithJson:examLocalDic];
        }
    }
    return [examsDataModel new];
}
@end
