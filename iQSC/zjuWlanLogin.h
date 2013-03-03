//
//  zjuWlanLogin.h
//  iNotice
//
//  Created by zy on 12-11-20.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "plistController.h"
#import "Reachability.h"
#import "MobileProbe.h"
#import <SystemConfiguration/CaptiveNetwork.h>
//server's url to post the login info

#define WLAN50_100_LOGINPAGE @"http://10.50.200.245/cgi-bin/do_login_juniper"
#define WLAN50_100_LOGOUTPAGE @"http://10.50.200.245/cgi-bin/do_logout_juniper"
#define WLAN1_1_1_1_LOGINPAGE @"https://1.1.1.1/login.html"
#define WLAN1_1_1_1_LOGOUTPAGE @"https://1.1.1.1/logout.html"
#define WLAN1_1_1_1_LOGINPAGE @"https://1.1.1.1/login.html"
#define WLAN1_1_1_1_TEST @"https://1.1.1.1/fs/customwebauth/login05.html"
#define WLAN50_100_TEST @"http://10.50.200.245"
#define LOGIN_TEST @"http://m.myqsc.com/get"
//the name of file containing user's xuhao and password
#define ZJU_USER_INFO_FILE @"zjuWLANUserInfo.plist"

#define TIME_OUT 1.5f
//msg NO.
#define SUCCESS 0
#define USERNAME_OR_PASSWORD_INCORRECT 1
#define NETWORK_ERROR 2
#define LACK_USERNAME_OR_PASSWORD 3

//location
#define WLAN1_1_1_1 100
#define WLAN50_100 101
#define UNZJUWLAN 199
@interface zjuWlanLogin : NSObject{
    NSMutableDictionary *userInfo_;
    BOOL done_;
    NSHTTPURLResponse *httpResponse;
    NSMutableString *httpData;
    NSInteger location_;
    BOOL isLogin_;
    
}
-(zjuWlanLogin *)init;
-(NSInteger)logIn:(NSDictionary *)userInfo;
-(void)logOut;
-(void)saveInfo;
-(NSDictionary *)loadInfo;
-(void)freshStatus;
-(NSInteger)judgeLocation;
-(BOOL)judgeLogin;
-(NSInteger)getLocation;
-(BOOL)isLogin;
-(NSMutableURLRequest *)setRequst:(NSString *)urlStr;
-(NSString *) getDeviceSSID;
@end
