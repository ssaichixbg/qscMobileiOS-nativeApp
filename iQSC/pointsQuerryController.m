//
//  pointsQuerryController.m
//  iQSC
//
//  Created by zy on 13-1-20.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "pointsQuerryController.h"

@implementation pointsQuerryController{
    qscApi *_qscRequest;//api请求实例
    zjuXuehaoDataModel *_currentUser;//当前用户
    NSMutableArray *_cache;//缓存（用于重复获取列表）
}

-(pointsQuerryController *)initWithDefaultUser{
    if (self = [super init]){
        _currentUser = [[[zjuXuehaoController alloc] init] getMainUser];
        _qscRequest = [[qscApi alloc]initUserApi:_currentUser];
        _cache = nil;
    }
    return self;
}
-(pointsQuerryController *)initWithDefaultUserOutline{
    if (self = [super init]){
        _currentUser = [[[zjuXuehaoController alloc] init] getMainUser];
        _qscRequest = nil;
        _cache = nil;
    }
    return self;
}
-(enum userAvailable)getState{
    if (_qscRequest) {
        return [_qscRequest userState];
    }
    else{
        return UNEXIST;
    }
}
-(BOOL)freshFromServer{
    //if (!_qscRequest) _qscRequest = [[qscApi alloc]initUserApi:_currentUser];
    if ([self getState] == CORRECT) {
        return [[plistController new] savePlistFile:[_qscRequest getChengji] dicName:[NSString stringWithFormat:CHENGJI_PLIST,_currentUser.stuid]];
    }
    return NO;
}
-(NSArray *)getGPALists{
    return [[[plistController new] loadPlistFileToDic:[NSString stringWithFormat:CHENGJI_PLIST,_currentUser.stuid]] valueForKey:@"junji_array"];
}
-(NSArray *)getSingleCourseLists{
    return [[[plistController new] loadPlistFileToDic:[NSString stringWithFormat:CHENGJI_PLIST,_currentUser.stuid]] valueForKey:@"chengji_array"];	
}
@end
