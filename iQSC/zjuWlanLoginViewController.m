//
//  zjuWlanLoginViewController.m
//  iNotice
//
//  Created by zy on 12-11-20.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "zjuWlanLoginViewController.h"
@interface zjuWlanLoginViewController (){
    UIActivityIndicatorView *activityIndicatorView;
     __block DemoHintView* hintLoggingView ;
     zjuWlanLogin *zju;
     
}

@end

@implementation zjuWlanLoginViewController
@synthesize txtPassWord,txtUserName,aFreshing,btnLogIn,btnLogOut,btnFreshing,lblStatus,imgBackground,btnChangeUI;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	        		
    //load activityIndicatorView
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(120.f, 48.0f, 37.0f, 37.0f)];
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;//color
    [self.view addSubview : activityIndicatorView] ;
    
    aFreshing.hidden = YES;
    [aFreshing stopAnimating];
    lblStatus.hidden = NO;
    
    txtPassWord.hidden = YES;
    txtUserName.hidden = YES;
    
    btnLogIn.hidden = NO;
    btnLogOut.hidden = YES;
    btnFreshing.hidden = NO;
    
    //load userinfo file
    NSLog(@"UI:request userinfo from core");
    NSDictionary *userInfo = [zju loadInfo];
    if(userInfo){
        txtUserName.text = [userInfo valueForKey:@"zjuUserName"];
        txtPassWord.text = [userInfo valueForKey:@"zjuPassWord"];
        NSLog(@"UI:load sucessfully");
    }
    else{
        NSLog(@"UI:failed to load userinfo");
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self startCheckStatus];
    [MobileProbe pageBeginWithName:@"zjuWlan一键登录view"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    if (zju) {
        zju = nil;
    }
     [MobileProbe pageEndWithName:@"zjuWlan一键登录view"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtUserName:nil];
    [self setTxtPassWord:nil];
    [self setAFreshing:nil];
    [self setLblStatus:nil];
    [self setBtnLogIn:nil];
    [self setBtnLogOut:nil];
    [self setBtnFreshing:nil];
    [self setImgBackground:nil];
    [self setBtnChangeUI:nil];
    [super viewDidUnload];
}

- (IBAction)btnFresh:(id)sender {
    [self startCheckStatus];
}
- (IBAction)btnLogIn:(id)sender {
    [txtPassWord resignFirstResponder];
    [txtUserName resignFirstResponder];
    NSLog(@"UI:btnLogIn pressed");
    [self startlogIn];
    
}
- (IBAction)btnChangeUI:(id)sender {
    [self changeUI];
}
- (IBAction)btnLogOut:(id)sender {
    NSLog(@"UI:btnLogOut pressed.");
    [activityIndicatorView startAnimating];
    //__block DemoHintView* hintLoggingView ;
    //[activityIndicatorView startAnimating];
    __block DemoHintView* hintView;
    hintLoggingView = [DemoHintView  infoHintView];
    // Overwrites the pages titles
    hintLoggingView.title = @"求是潮－提示";
    hintLoggingView.hintID = kHintID_Home;
    [hintLoggingView addPageWithTitle:@"ZJUWLAN" text:@"请稍候..."];
    [hintLoggingView showInView:self.view orientation:kHintViewOrientationBottom];
    
    [zju logOut];
    
    [hintLoggingView dismiss];
    [activityIndicatorView stopAnimating];
    
    hintView = [DemoHintView  infoHintView];
    // Overwrites the pages titles
    hintView.title = @"求是潮－提示";
    hintView.hintID = kHintID_Home;
    [hintView addPageWithtitle:@"ZJUWLAN" text:@"注销成功！" buttonText:@"好的嘛" buttonAction:^{
        [DemoHintView enableHints:NO];
        [hintView dismiss];
    }];
    
    [self startCheckStatus];
    [hintView showInView:self.view orientation:kHintViewOrientationTop];
    return;
    
}


- (IBAction)touchBackground:(id)sender {
    [txtPassWord resignFirstResponder];
    [txtUserName resignFirstResponder];
}

- (IBAction)finishInputId:(id)sender {
    [txtPassWord becomeFirstResponder];
}

- (IBAction)finishInputPassWord:(id)sender {
    [txtPassWord resignFirstResponder];
    [self startlogIn];
}

//fresh status label
- (void)startCheckStatus{
    if (!aFreshing.hidden) {//is freshing?
        return;
    }
    aFreshing.hidden = NO;
    lblStatus.text = TEXT_FRESHING;
    
    btnLogIn.hidden = YES;
    btnLogOut.hidden = YES;
    
    [aFreshing startAnimating];
    
    [NSThread detachNewThreadSelector:@selector(checkStatus) toTarget:self withObject:nil];
}

- (void)checkStatus{
    NSLog(@"UI:checkNework request sent to core.");
    NSNumber *isLogin,*isZjuWlan;
    if (!zju) {
        zju = [[zjuWlanLogin alloc] init];
    }
    [zju freshStatus];
    if ([zju getLocation] == UNZJUWLAN) {
        isLogin = [NSNumber numberWithBool:0];
        isZjuWlan = [NSNumber numberWithBool:0];
    }
    else {
        isZjuWlan = [NSNumber numberWithBool:1];
        if ([zju isLogin]) {
            isLogin = [NSNumber numberWithBool:1];
        }
        else{
            isLogin = [NSNumber numberWithBool:0];
        }
    }
    NSDictionary *msg = [NSDictionary dictionaryWithObjectsAndKeys:isLogin,@"isLogin",isZjuWlan,@"isZjuWlan", nil];
    NSLog(@"UI:got result from core.");
        
    [self performSelectorOnMainThread:@selector(freshStatus:) withObject:msg waitUntilDone:NO];
}
- (void)freshStatus:(NSDictionary *)msg{
    //cartoon
    UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,340, 320, self.view.frame.size.height-45)];
    [splashView setBackgroundColor:[UIColor whiteColor]];
    splashView.alpha = 1.0;
    [self.view addSubview:splashView];
    [self.view bringSubviewToFront:splashView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView: self.view cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashView.alpha = 0.0;
    //splashView.frame = CGRectMake(-60, -85, 440, 635);
    [UIView commitAnimations];

   //after freshing
    if([(NSNumber *)[msg objectForKey:@"isLogin"] boolValue]){
        lblStatus.text = TEXT_LOGIN;
        btnLogIn.hidden = YES;
        btnLogOut.hidden = NO;
        aFreshing.hidden = YES;
        [aFreshing stopAnimating];
        return;
    }
    if([(NSNumber *)[msg objectForKey:@"isZjuWlan"] boolValue]){
        //able to login
        lblStatus.text = TEXT_UNLOGIN;
        
        
    }
    else{        
        lblStatus.text = TEXT_UNZJUWLAN;
    }
    btnLogIn.hidden = NO;
    //[self.view bringSubviewToFront:btnLogIn];
    btnLogOut.hidden = YES;
    aFreshing.hidden = YES;
    [aFreshing stopAnimating];
}
- (void)changeUI{
    //cartoon
    UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,100, 320, self.view.frame.size.height-45)];
    [splashView setBackgroundColor:[UIColor whiteColor]];
    splashView.alpha = 0.8;
    [self.view addSubview:splashView];
    [self.view bringSubviewToFront:splashView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView: self.view cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashView.alpha = 0.0;
    //splashView.frame = CGRectMake(-60, -85, 440, 635);
    [UIView commitAnimations];
    txtUserName.hidden = !txtUserName.hidden;
    txtPassWord.hidden = !txtPassWord.hidden;
    lblStatus.hidden = !lblStatus.hidden;
    btnFreshing.hidden = !btnFreshing.hidden;
    
    if (lblStatus.hidden) {
        //change to login page
        imgBackground.image = [UIImage imageNamed:@"UI_Zjuwlan_Login.png"];
        btnLogOut.hidden =YES;
        //[btnChangeUI setBackgroundImage:[UIImage imageNamed:@"arrow-l.png"] forState:UIControlStateNormal];
        //[btnChangeUI setBackgroundImage:[UIImage imageNamed:@"arrow-l.png"] forState:UIControlStateHighlighted];
        [btnChangeUI setTitle:@"返回" forState:UIControlStateNormal];
        [btnChangeUI setTitle:@"返回" forState:UIControlStateHighlighted];
        [btnChangeUI setFrame:CGRectMake(235, 25, 60, 60)];

        btnLogIn.hidden =NO;
        //[self.view bringSubviewToFront:btnLogIn];
        float i = btnLogIn.frame.origin.y;
        while (btnLogIn.frame.origin.y > 220) {
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
            i -= 5;
            [btnLogIn setFrame:CGRectMake(20, i, 276, 59)];
        }
                        
    }
    else{
        //change to main page
        imgBackground.image = [UIImage imageNamed:@"UI_Zjuwlan.png"];
        btnLogOut.hidden =YES;
        btnLogOut.hidden =YES;
        [btnLogIn setFrame:CGRectMake(20, 340, 276, 59)];
        [btnChangeUI setFrame:CGRectMake(240, 188, 70, 20)];
        [btnChangeUI setTitle:@"切换用户" forState:UIControlStateNormal];
        [btnChangeUI setTitle:@"切换用户" forState:UIControlStateHighlighted];
        [self startCheckStatus];
    }
    
    
}

- (void)startlogIn{
    __block DemoHintView* hintView;
    
    if ([txtUserName.text isEqualToString:@""] || [txtPassWord.text isEqualToString:@""]) {
        if (!lblStatus.hidden){
            [self changeUI];//change ui
            return;
        }
        hintView = [DemoHintView  infoHintView];
        // Overwrites the pages titles
        hintView.title = @"求是潮－提示";
        hintView.hintID = kHintID_Home;
        [hintView addPageWithtitle:@"ZJUWLAN" text:@"请输入用户名，密码。" buttonText:@"好的嘛" buttonAction:^{
            [DemoHintView enableHints:NO];
            [hintView dismiss];
        }];
        [hintLoggingView dismiss];
        return;
    }
    else if ([zju getLocation] == UNZJUWLAN){
        [self startCheckStatus];
        hintView = [DemoHintView  infoHintView];
        // Overwrites the pages titles
        hintView.title = @"求是潮－提示";
        hintView.hintID = kHintID_Home;
        [hintView addPageWithtitle:@"ZJUWLAN" text:@"抱歉，您没有连接到ZJUWLAN。请到 设置－无线局域网 里连接。" buttonText:@"好的嘛" buttonAction:^{
            [DemoHintView enableHints:NO];
            [hintView dismiss];
        }];
        [hintView showInView:self.view orientation:kHintViewOrientationTop];
        [hintLoggingView dismiss];
        return;
    }
    else if ([zju isLogin]) {
        [self startCheckStatus];
        hintView = [DemoHintView  infoHintView];
        // Overwrites the pages titles
        hintView.title = @"求是潮－提示";
        hintView.hintID = kHintID_Home;
        [hintView addPageWithtitle:@"ZJUWLAN" text:@"您已登陆。" buttonText:@"好的嘛" buttonAction:^{
            [DemoHintView enableHints:NO];
            [hintView dismiss];
        }];
        [hintView showInView:self.view orientation:kHintViewOrientationTop];
        [hintLoggingView dismiss];
        return;
    }

    hintLoggingView = [DemoHintView  infoHintView];
    // Overwrites the pages titles
    hintLoggingView.title = @"求是潮－提示";
    hintLoggingView.hintID = kHintID_Home;
    [hintLoggingView addPageWithTitle:@"ZJUWLAN" text:@"请稍候..."];
    [hintLoggingView showInView:self.view orientation:kHintViewOrientationBottom];
    [NSThread detachNewThreadSelector:@selector(logIn) toTarget:self withObject:nil];
}

- (void)logIn{
    [MobileProbe triggerEventWithName:@"zjuWlan一键登录发起" count:1];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:txtUserName.text,@"zjuUserName",
                              txtPassWord.text,@"zjuPassWord",  nil];
    NSLog(@"UI:login request sent to core. ");
    
    NSNumber *result =[NSNumber numberWithInt:[zju logIn:userInfo]] ;
    NSLog(@"UI:got result from core.");
    [self performSelectorOnMainThread:@selector(freshLogInUI:) withObject:result waitUntilDone:NO];
       
}
- (void)freshLogInUI:(NSNumber *)msg{
    [hintLoggingView dismiss];
    if (lblStatus.hidden) {
        [self changeUI];
    }
    
   __block DemoHintView* hintView ;
    switch ([msg intValue]) {
        case SUCCESS:
            hintView = [DemoHintView  infoHintView];
            // Overwrites the pages titles
            hintView.title = @"求是潮－提示";
            hintView.hintID = kHintID_Home;
            [hintView addPageWithtitle:@"ZJUWLAN" text:@"登录成功!" buttonText:@"好的嘛" buttonAction:^{
                [DemoHintView enableHints:NO];
                [hintView dismiss];
            }];
            break;
        case USERNAME_OR_PASSWORD_INCORRECT:
            hintView = [DemoHintView  infoHintView];
            // Overwrites the pages titles
            hintView.title = @"求是潮－提示";
            hintView.hintID = kHintID_Home;
            [hintView addPageWithtitle:@"ZJUWLAN" text:@"密码错误:(" buttonText:@"好的嘛" buttonAction:^{
                [DemoHintView enableHints:NO];
                [hintView dismiss];
            }];
            break;
        case LACK_USERNAME_OR_PASSWORD:
            hintView = [DemoHintView  infoHintView];
            // Overwrites the pages titles
            hintView.title = @"求是潮－提示";
            hintView.hintID = kHintID_Home;
            [hintView addPageWithtitle:@"ZJUWLAN" text:@"请输入用户名，密码。" buttonText:@"好的嘛" buttonAction:^{
                [DemoHintView enableHints:NO];
                [hintView dismiss];
            }];
            break;
        case NETWORK_ERROR:
            hintView = [DemoHintView  infoHintView];
            // Overwrites the pages titles
            hintView.title = @"求是潮－提示";
            hintView.hintID = kHintID_Home;
            [hintView addPageWithtitle:@"ZJUWLAN" text:@"抱歉，网络错误。请重试..." buttonText:@"好的嘛" buttonAction:^{
                [DemoHintView enableHints:NO];
                [hintView dismiss];
            }];
            break;
    }
    [hintView showInView:self.view orientation:kHintViewOrientationTop];
    [self startCheckStatus];

}

@end
