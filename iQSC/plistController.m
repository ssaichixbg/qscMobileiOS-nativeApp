//
//  plistController.m
//  iNotice
//
//  Created by zy on 12-11-4.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "plistController.h"

@implementation plistController
//get complete path accroding to file's name
-(NSString *)getPath:(NSString *)path{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *pathname = [paths objectAtIndex:0];
	return [pathname stringByAppendingPathComponent:path ];
    
}
//load the plist file accroding to file's name
-(NSMutableDictionary *)loadPlistFileToDic:(NSString *)path{
    NSFileManager *fileManager =[NSFileManager defaultManager];
    path = [self getPath:path];
    if ([fileManager fileExistsAtPath:path]){
        NSMutableDictionary *plist ;
        @try{
            plist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
            NSLog(@"plistController class:load successful!");
            return plist;
        }
        @catch (NSException *ex) {
            NSLog(@"plistController class: error while loading plist file. %@",ex);
            return nil;
        }
    }
    return nil;
}

-(BOOL)savePlistFile:(NSDictionary *)plist arrayName:(NSString *)pathStr{
    @try{
        [plist writeToFile:[self getPath:pathStr] atomically:YES];
        NSLog(@"plistController class:save successful!");
        return YES;
    }
    @catch(NSException *ex){
        NSLog(@"plistController class: error while saving plist file. %@",ex);
        return NO;
    }
}
//load the plist file accroding to file's name
-(NSMutableArray *)loadPlistFileToArr:(NSString *)path{
    NSFileManager *fileManager =[NSFileManager defaultManager];
    path = [self getPath:path];
    if ([fileManager fileExistsAtPath:path]){
        NSMutableArray *plist ;
        @try{
            plist = [[NSMutableArray alloc] initWithContentsOfFile:path];
            NSLog(@"plistController class:load successful!");
            return plist;
        }
        @catch (NSException *ex) {
            NSLog(@"plistController class: error while loading plist file. %@",ex);
            return nil;
        }
    }
    return nil;
}

-(BOOL)savePlistFile:(NSDictionary *)plist dicName:(NSString *)pathStr{
    @try{
        [plist writeToFile:[self getPath:pathStr] atomically:YES];
        NSLog(@"plistController class:save successful!");
        return YES;
    }
    @catch(NSException *ex){
        NSLog(@"plistController class: error while saving plist file. %@",ex);
        return NO;
    }
}

@end
