//
//  TabBarViewController.m
//  iNotice
//
//  Created by zy on 12-11-28.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController
@synthesize _zjuer;
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
    self.delegate = self;
    
    
    [NSThread detachNewThreadSelector:@selector(checkZjuWLan) toTarget:self withObject:nil];
}
-(void)checkZjuWLan{
    // jugde network
    zjuWlanLogin* zju = [[zjuWlanLogin alloc] init];
    if ([zju getLocation] != UNZJUWLAN && ![zju isLogin]) {
        [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
    }

}
-(void)showAlert{
    __block DemoHintView* hintView = [DemoHintView  infoHintView];
    
    // Overwrites the pages titles
    hintView.title = @"求是潮－提示";
    
    hintView.hintID = kHintID_Home;
    
    [hintView addPageWithtitle:@"ZJUWLAN" text:@"检测到您已经连接到ZJUWLAN网络，是否登录？" buttonText:@"一键登录" buttonAction:^{
        [DemoHintView enableHints:NO];
        //[hintView dismiss];
        self.selectedIndex=1;
    }];
    [hintView showInView:self.view orientation:kHintViewOrientationBottom];
}
-(void)viewDidAppear:(BOOL)animated{
   

}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController == self.selectedViewController) {//select current page
        return NO;
    }
    
    /*/cartoon
    UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, self.view.frame.size.height-45)];
    [splashView setBackgroundColor:[UIColor whiteColor]];
    splashView.alpha = 0.8;
    [self.view addSubview:splashView];
    [self.view bringSubviewToFront:self.tabBar];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView: self.view cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashView.alpha = 0.0;
    //splashView.frame = CGRectMake(-60, -85, 440, 635);
    [UIView commitAnimations];*/
    //if the destination view controllser supports fresh data
    if ([self.selectedViewController respondsToSelector:@selector(fresh:)]) {
        [self.selectedViewController performSelectorOnMainThread:@selector(fresh:) withObject:nil waitUntilDone:NO ];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
