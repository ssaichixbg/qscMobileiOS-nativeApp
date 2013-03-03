//
//  zjuXuehaoController.h
//  iQSC
//
//  Created by zy on 13-1-29.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "qscApi.h"
#import "zjuXuehaoDataModel.h"
#import "plistController.h"
#import "coreUserHeader.h"
#import "coreSystemHeader.h"

@interface zjuXuehaoController : NSObject
-(zjuXuehaoController *)initFirstLogin:(zjuXuehaoDataModel *)user;
-(zjuXuehaoDataModel *)getUserByStuid:(NSString *)stuid;
-(NSArray *)showAllUsers;
-(BOOL)addUser;
-(BOOL)addUser:(zjuXuehaoDataModel *)user;
-(BOOL)deleteUser:(zjuXuehaoDataModel *)user;
-(NSString *)getName;
-(NSString *)getName:(zjuXuehaoDataModel *)user;
-(enum userAvailable)getState;
-(void)setMainUser:(zjuXuehaoDataModel *)user;
-(zjuXuehaoDataModel *)getMainUser;
-(NSString *)getMainUserStuid;

@end
