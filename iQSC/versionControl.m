//
//  versionControll.m
//  iQSC
//
//  Created by zy on 12-12-16.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "versionControl.h"

@implementation versionControl
-(void)firstLauch{
    [[NSUserDefaults standardUserDefaults] setValue:@"2.00" forKey:@"version"];//set current version
    [self updateSystemData];
}

-(BOOL)checkNewVersion{
    Reachability *chekNet = [Reachability reachabilityWithHostname:@"www.apple.com"];//check network connection
    if([chekNet isReachable]){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://itunes.apple.com/lookup?id=%@",APPSTORE_ID]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingAllowFragments error:&error];
        NSArray *infoArray = [dic objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"version"] count]) {
                return NO;
            }
            if (![lastVersion isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"version"]]){
                return YES;
            }
            else
                return NO;
        }
        else{
            return NO;
        }
   
    }
    else{
        return NO;
    }
}
-(void)updateAllData{
    [self updateSystemData];
    [self updateUserData];
    
}
-(void)updateSystemData{
    [[publicInfoController new] freshFromServer];
}
-(void)updateUserData{
    [[[classTableController alloc] initWithDefaultUser] freshFromServer];
    [[[examQuerryController alloc] initWithDefaultUser] freshFromServer];
    [[[pointsQuerryController alloc] initWithDefaultUser] freshFromServer];
}
@end

