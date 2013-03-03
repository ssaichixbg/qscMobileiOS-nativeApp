//
//  zjuWlanLogin.m
//  iNotice
//
//  Created by zy on 12-11-20.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "zjuWlanLogin.h"
@implementation zjuWlanLogin
-(zjuWlanLogin *)init{
    if (self = [super init]) {
        [self freshStatus];
    }
    return self;
}
-(BOOL)isLogin{
    return isLogin_;
}
-(NSInteger)getLocation{
    return location_;
}
-(void)freshStatus{
    [self judgeLocation];
    [self judgeLogin];
}
-(NSMutableURLRequest *)setRequst:(NSString *)urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:TIME_OUT];//time limit
    [request setURL:url];
    [request setValue:@"Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_2_1 like Mac OS X; zh-cn) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5" forHTTPHeaderField:@"Üser-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return request;

}
-(BOOL)judgeLogin{
    //check ZJUWLAN connection
    if(location_ == UNZJUWLAN){
        return isLogin_ = NO;
    }
    NSHTTPURLResponse *response;
    NSError *er;
    NSData *data = [NSURLConnection sendSynchronousRequest:[self setRequst:LOGIN_TEST] returningResponse:&response error:&er];
    if([response allHeaderFields]){
        //NSInteger length = [[[response allHeaderFields] valueForKey:@"Content-Length"] integerValue];
        if([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] rangeOfString:@"apple.com"].length > 0){
            NSLog(@"zjuWlanLogin Class:logged in");
            return isLogin_ = YES;
        }
        else{
            NSLog(@"zjuWlanLogin Class:haven't logged in");
            return isLogin_ = NO;
        }
    }
    else{
    NSLog(@"zjuWlanLogin Class:haven't logged in.Network Error.");
    return isLogin_ = NO;
    }
}
-(NSInteger)judgeLocation{
    NSHTTPURLResponse *response;
    NSError *er;
    NSInteger length=0;
    //check wifi connection
    /*if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != ReachableViaWiFi){
        NSLog(@"zjuWlanLogin Class:out of ZJUWLAN");
        return location_ = UNZJUWLAN;
    }*/
    if (![[self getDeviceSSID] isEqualToString:@"ZJUWLAN"]) {
        NSLog(@"zjuWlanLogin Class:out of ZJUWLAN");
        return location_ = UNZJUWLAN;
    }
    
    NSURLConnection *conn;
    conn = [[NSURLConnection alloc] initWithRequest:[self setRequst:WLAN1_1_1_1_TEST] delegate:self];
    //wait for done/		
    done_=NO;
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
    } while (!done_);
    
    if([httpResponse allHeaderFields]){
        length= [[[response allHeaderFields] valueForKey:@"Content-Length"] integerValue];
        NSLog(@"zjuWlanLogin Class:location:1.1.1.1");
        return location_ = WLAN1_1_1_1;
    }
    
    [NSURLConnection sendSynchronousRequest:[self setRequst:WLAN50_100_TEST] returningResponse:&response error:&er];
    if([response allHeaderFields]){
        //length = [[[response allHeaderFields] valueForKey:@"Content-Length"] integerValue];
        NSLog(@"zjuWlanLogin Class:location:50.100");
        return location_ = WLAN50_100;
    }
    
    NSLog(@"zjuWlanLogin Class:out of ZJUWLAN");
    return location_ = UNZJUWLAN;
}
-(NSInteger)logIn:(NSDictionary *)userInfo{
    if([self isLogin]){
        [self logOut];
    };
    
    NSString *username = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"zjuUserName"] ];
    NSString *password = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"zjuPassWord"] ];
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        NSLog(@"zjuWlanLogin Class:lack of username or password");
        return LACK_USERNAME_OR_PASSWORD;
    }
    
    userInfo_ = [[NSMutableDictionary alloc] initWithObjectsAndKeys:username,@"zjuUserName",password,@"zjuPassWord", nil];
    [self saveInfo];
    
    
    //sendLoginInfo
    //prepare http request
    NSMutableURLRequest *urlRequest;
    NSData *postData;
    NSString *postStr;
    NSLog(@"zjuWlanLogin Class:judge location...");
    static int times = 0;
    switch (location_) {
        case WLAN1_1_1_1:
            urlRequest = [self setRequst:WLAN1_1_1_1_LOGINPAGE];
            postStr = [NSString stringWithFormat:@"buttonClicked=4&err_flag=0&err_msg=&info_flag=0&info_msg=&redirect_url=&username=%@&password=%@",[userInfo objectForKey:@"zjuUserName"],[userInfo objectForKey:@"zjuPassWord"]];
            NSLog(@"%@",postStr);
            //prepare post data
            postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
            [urlRequest setHTTPBody:postData];
            [urlRequest setValue:[NSString stringWithFormat:@"%d",postData.length] forHTTPHeaderField:@"Content-Length"];
            break;
        case WLAN50_100:
            urlRequest = [self setRequst:WLAN50_100_LOGINPAGE];
            postStr = [NSString stringWithFormat:@"n=100&is_pad=1&type=1&username=%@&password=%@&drop=0",[userInfo objectForKey:@"zjuUserName"],[userInfo objectForKey:@"zjuPassWord"]];
            //prepare post data
            postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
            [urlRequest setHTTPBody:postData];
            [urlRequest setValue:[NSString stringWithFormat:@"%d",postData.length] forHTTPHeaderField:@"Content-Length"];
            break;
        case UNZJUWLAN:
        default:
            times++;
            [self freshStatus];
            if (times < 2) {
                [self logIn:userInfo];
            }
            break;
    }
    
    //send request
    NSLog(@"zjuWlanLogin Class:start to send logging request");
    NSURLConnection *conn;
    conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    //wait for http requesting done
    done_ = NO;
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
    } while (!done_);
    NSLog(@"%@",httpData);
    if([httpData rangeOfString:@"成功"].length >0 || [httpData rangeOfString:@"Successful"].length >0){
        NSLog(@"zjuWlanLogin Class:login successfully");
        [MobileProbe triggerEventWithName:@"zjuWlan一键登录成功" count:1];
        return SUCCESS;
    }
    else if([httpData rangeOfString:@"错误"].length >0 || [httpData rangeOfString:@"invalid"].length >0){
        NSLog(@"zjuWlanLogin Class:the username or password is wrong");
        return USERNAME_OR_PASSWORD_INCORRECT;
    }
    else{
        NSLog(@"zjuWlanLogin Class:failed to login");
        [MobileProbe reportError:[NSString stringWithFormat:@"登录失败，地点：%d",[self getLocation]]];
        return NETWORK_ERROR;
    }
}

//connection app delecate
//receive http head
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response{
    httpResponse = (NSHTTPURLResponse *)response;
    httpData = [[NSMutableString alloc] initWithFormat:@""];
    return;
}
- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data{
    [httpData appendString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    return;
}
// Forward errors to the delegate.
- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
    NSLog(@"Error when send http connection.The error is :%@",error);
    done_ = YES;
    return;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    done_ = YES;
    return;
    //[self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
}
//https
- (BOOL)connection:(NSURLConnection *)conn canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
- (void)connection:(NSURLConnection *)conn didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"zjuWlanLogin Class:didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
}


-(void)logOut{
    NSMutableURLRequest *urlRequest;
    NSString *postStr;
    NSData *postData;
    NSURLConnection *conn;
    static int times = 0;
    
    switch (location_) {
        case WLAN1_1_1_1:
            NSLog(@"zjuWlanLogin Class:sending 1.1.1.1 logging out request");
            //send 1.1.1.1 logout request
            urlRequest = [self setRequst:WLAN1_1_1_1_LOGOUTPAGE];
            postStr = @"userStatus=1&err_flag=0&err_msg=";
            //prepare post data
            postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
            [urlRequest setHTTPBody:postData];
            [urlRequest setValue:[NSString stringWithFormat:@"%d",postData.length] forHTTPHeaderField:@"Content-Length"];
            conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            done_=NO;
            //do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:TIME_OUT]];
            //} while (!done_);
            break;
        case WLAN50_100:
            NSLog(@"zjuWlanLogin Class:sending 50.100 logging out request");
            //send 50.100 logout request
            urlRequest = [self setRequst:WLAN50_100_LOGOUTPAGE];
            [urlRequest setValue:[NSString stringWithFormat:@"%d",4096] forHTTPHeaderField:@"Content-Length"];
            [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
            break;
        case UNZJUWLAN:
            return;
        default:
            times ++;
            [self freshStatus];
            if (times < 2) [self logOut];
            return;
    }
    [MobileProbe triggerEventWithName:@"zjuWlan一键登录注销" count:1];
    NSLog(@"sended");

}
-(void)changeUser{
    
}

-(void)saveInfo{
    NSLog(@"zjuWlanLogin Class:save user info");
    [[plistController new] savePlistFile:userInfo_ dicName:ZJU_USER_INFO_FILE];
}
-(NSDictionary *)loadInfo{
    NSMutableDictionary *userInfo = [[plistController new] loadPlistFileToDic:ZJU_USER_INFO_FILE];
    userInfo_=userInfo;
    NSLog(@"zjuWlanLogin Class:load user info");
    return userInfo_;
}
-(NSString *)getDeviceSSID{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
            
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *ssid = [dctySSID objectForKey:@"SSID"] ;
    NSLog(@"core:the SSID is %@",ssid);
    return ssid;
}

@end
