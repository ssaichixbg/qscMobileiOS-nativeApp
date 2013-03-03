//
//  TabBarViewController.h
//  iNotice
//
//  Created by zy on 12-11-28.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zjuWlanLogin.h"
#import "DemoHintView.h"
#import "UIHeader.h"
#import "AppDelegate.h"
#import "coreUserHeader.h"

@interface TabBarViewController : UITabBarController<UITabBarControllerDelegate>
- (void)showAlert;
- (void)checkZjuWLan;

@property (nonatomic,strong) zjuXuehaoDataModel *_zjuer;
@end
