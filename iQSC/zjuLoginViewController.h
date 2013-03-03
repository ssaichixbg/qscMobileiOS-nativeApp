//
//  zjuLoginViewController.h
//  iQSC
//
//  Created by zy on 13-1-30.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zjuXuehaoController.h"
#import "UIHeader.h"
#import "coreUserHeader.h"

@interface zjuLoginViewController : UIViewController<UITextFieldDelegate>
- (IBAction)txtUserNameEndEditing:(id)sender;
- (IBAction)txtPassWordEndEditing:(id)sender;
- (IBAction)btnOk:(id)sender;
- (IBAction)viewTouchBackground:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassWord;

@property (nonatomic,strong) NSNumber *canDismiss;
@property (nonatomic,strong) id delegate;
-(void)startLogin;
-(void)loggingIn;
-(void)endLoggingIn:(NSDictionary *)info;
- (IBAction)btnBack:(id)sender;

@end
