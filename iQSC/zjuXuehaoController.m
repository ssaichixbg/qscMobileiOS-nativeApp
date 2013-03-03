//
//  zjuXuehaoController.m
//  iQSC
//
//  Created by zy on 13-1-29.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "zjuXuehaoController.h"

@implementation zjuXuehaoController{
    zjuXuehaoDataModel *_zjuer;
    enum userAvailable _currentState;
}

//第一次登录初始化
-(zjuXuehaoController *)initFirstLogin:(zjuXuehaoDataModel *)user{
    if (self = [super init]){
        _zjuer = user;
        NSLog(@"zjuXuehao:accepted user info");
        //send a api request
        qscApi *request = [[qscApi alloc] initUserApi:user];
        _currentState =[request userState];
        //user info is correct
        if (_currentState == CORRECT) {
            //add name etc. info
            [_zjuer addInfoWithWebJson:[request getStuInfo]];
            //save user info
            [self addUser];
            [[versionControl new] updateUserData];
        }
    }
    return self;
    
}
-(zjuXuehaoController *)init{
    if (self = [super init]) {
        _currentState = UNEXIST;
    }
    return self;
}
-(zjuXuehaoDataModel *)getUserByStuid:(NSString *)stuid{
    NSArray *users = [self showAllUsers];
    for (int i = 0;i<[users count]; i++) {
        if ([[[users objectAtIndex:i] valueForKey:@"stuid"] isEqualToString:stuid]) {
            return [[zjuXuehaoDataModel alloc] initWithLocalJson:[users objectAtIndex:i]];
        }
    }
    return nil;
}
-(NSArray *)showAllUsers{
    return [[plistController new] loadPlistFileToArr:ZJU_XUEHAO_PLIST];
}
-(BOOL)addUser{
    return [self addUser:_zjuer];
}
-(BOOL)addUser:(zjuXuehaoDataModel *)user{
    if (_currentState != CORRECT) {
        return NO;
    }
    NSLog(@"zjuXuehao:add user");
    //load plist
    NSMutableArray *users = [[plistController new] loadPlistFileToArr:ZJU_XUEHAO_PLIST];
    user.xsid = [[user getid] integerValue];
    if (users && [users count]>0) {
        for (int i = 0; i< [users count]; i++) {
            if ([[[users objectAtIndex:i] objectForKey:@"stuid"] isEqualToString:user.stuid]) {
                [users removeObjectAtIndex:i];//if student exists
            }
        }
        [users addObject:[user returnDic]];
    }
    else{
        //plist dont exist or is empty
        NSLog(@"zjuXuehao:the user is the first user");
        users = [NSArray arrayWithObject:[user returnDic]];
    }
    if ([[plistController new] savePlistFile:users arrayName:ZJU_XUEHAO_PLIST]) {
        [self setMainUser:user];
        return YES;
    }
    else return NO;
}
-(BOOL)deleteUser:(zjuXuehaoDataModel *)user{
    NSLog(@"zjuXuehao:delete user");
    //load plist
    NSMutableArray *users = [[plistController new] loadPlistFileToArr:ZJU_XUEHAO_PLIST];
    if (!users || [users count] == 0) return NO;
    BOOL isDeleted = NO;
    for (int i = 0; i < [users count] ; i++) {
        if ([[[users objectAtIndex:i] valueForKey:@"stuid"] isEqualToString:user.stuid]) {
            [users removeObjectAtIndex:i];
            isDeleted = YES;
        }
    }
    if (!isDeleted) return NO;//don't find the user being deleted
    if ([[plistController new] savePlistFile:users arrayName:ZJU_XUEHAO_PLIST]) {
        if ([[self getMainUserStuid] isEqualToString:user.stuid]) {//the user deleted is the default user
            if ([users count] >0)
            [self setMainUser:[[zjuXuehaoDataModel alloc] initWithLocalJson:[users objectAtIndex:0]]];
        }
        return YES;
    }
    else return NO;
}
-(NSString *)getName{
    return [self getName:_zjuer];
}
-(NSString *)getName:(zjuXuehaoDataModel *)user{
    qscApi *qscApiRequest = [[qscApi alloc] initUserApi:_zjuer];
    NSArray *kaoshiArr = [qscApiRequest getKaoshi];
    if ([kaoshiArr count] > 0){
        NSString *name = [[kaoshiArr objectAtIndex:0] valueForKey:@"姓名"];
        if ([name length] > 0) {
            return name;
        }
    }
    
    return @"Zjuer";
}
-(enum userAvailable)getState{
    return _currentState;
}
-(void)setMainUser:(zjuXuehaoDataModel *)user{
    [[NSUserDefaults standardUserDefaults] setObject:user.stuid forKey:@"main_zju_stuid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(zjuXuehaoDataModel *)getMainUser{
    return [self getUserByStuid:[[NSUserDefaults standardUserDefaults] objectForKey:@"main_zju_stuid"]];
}
-(NSString *)getMainUserStuid{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"main_zju_stuid"];
}
@end
