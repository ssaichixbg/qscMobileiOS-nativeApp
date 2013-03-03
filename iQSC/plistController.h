//
//  plistController.h
//  iNotice
//
//  Created by zy on 12-11-4.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface plistController : NSObject{
    
}
-(NSMutableDictionary *)loadPlistFileToDic:(NSString *)path;
-(BOOL)savePlistFile:(NSDictionary *)plist dicName:(NSString *)pathStr;
-(NSMutableArray *)loadPlistFileToArr:(NSString *)path;
-(BOOL)savePlistFile:(NSArray *)plist arrayName:(NSString *)pathStr;
-(NSString *)getPath:(NSString *)path;
@end
