//
//  zjuLoginViewController.m
//  iQSC
//
//  Created by zy on 13-1-30.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "zjuLoginViewController.h"

@interface zjuLoginViewController (){
    XYAlertView *alertView;
    XYLoadingView *loadingView;
}
     
@end

@implementation zjuLoginViewController
@synthesize txtPassWord,txtUserName,delegate,canDismiss;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (zjuLoginViewController *)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]) {
        canDismiss = [NSNumber numberWithBool:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    alertView = nil;
    loadingView = nil;
    UIGlossyButton *b = nil;
    
    b = (UIGlossyButton*) [self.view viewWithTag: 1000];//confirm button
    [b useWhiteLabel: YES];
    b.buttonCornerRadius = 8.0; b.buttonBorderWidth = 1.0f;
	[b setStrokeType: kUIGlossyButtonStrokeTypeBevelUp];
    b.tintColor = b.borderColor = [UIColor colorWithRed:70.0f/255.0f green:105.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
    b = (UIGlossyButton*) [self.view viewWithTag: 1001];//back button
    b.hidden = ![self.canDismiss boolValue];
	[b useWhiteLabel: YES];
    b.buttonCornerRadius = 8.0; b.buttonBorderWidth = 1.0f;
	[b setStrokeType: kUIGlossyButtonStrokeTypeBevelUp];
    b.tintColor = b.borderColor = [UIColor colorWithRed:70.0f/255.0f green:105.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
    
    txtPassWord.delegate = txtUserName.delegate = self;
	// Do any additional setup after loading the view.
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
       
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    float width=self.view.frame.size.width;
    float height=self.view.frame.size.height;
    CGRect rect=CGRectMake(0.0f,-10*(textField.tag),width,height);//上移80个单位，一般也够用了
    self.view.frame=rect;
    [UIView commitAnimations];
    
    return YES;
}

-(void)done:(id)sender
{
    [txtPassWord resignFirstResponder];
    [txtUserName resignFirstResponder];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    float width=self.view.frame.size.width;
    float height=self.view.frame.size.height;
    CGRect rect=CGRectMake(0.0f,0.0f,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)txtUserNameEndEditing:(id)sender {
    //[txtPassWord becomeFirstResponder];
}

- (IBAction)txtPassWordEndEditing:(id)sender {
    [self startLogin];
}

- (IBAction)btnOk:(id)sender {
    [self startLogin];
}

- (IBAction)viewTouchBackground:(id)sender {
    [self done:self];
}

-(void)startLogin{
    [self done:self];

    if ([txtUserName.text length] ==10 && [txtPassWord.text length]>0) {
        loadingView = [XYLoadingView loadingViewWithMessage:MSG_VALID_USER];
        [loadingView show];
        [NSThread detachNewThreadSelector:@selector(loggingIn) toTarget:self withObject:nil];
    }
    else if([txtUserName.text length] !=10 && [txtPassWord.text length]>0){
        XYShowAlert(MSG_UNEXIST_USER);
    }
    else{
        XYShowAlert(MSG_EMPTY_UM_OR_PW);
    }
}
-(void)loggingIn{
    if (reachable ==  NotReachable) {
        XYShowAlert(MSG_UNCONNECT);
        return;
    }
    
    zjuXuehaoDataModel *zjuer = [zjuXuehaoDataModel new];
    zjuer.stuid = txtUserName.text;
    zjuer.password = txtPassWord.text;
    
    zjuXuehaoController *zjuXuehao = [[zjuXuehaoController alloc] initFirstLogin:zjuer];
    enum userAvailable userAvailable= [zjuXuehao getState];
    
    [self performSelectorOnMainThread:@selector(endLoggingIn:) withObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:userAvailable] forKey:@"userAvailable"] waitUntilDone:YES];
}
-(void)endLoggingIn:(NSDictionary *)info{
    enum userAvailable userAvailable = (enum userAvailable)[[info objectForKey:@"userAvailable"] integerValue];
    switch (userAvailable) {
        case CORRECT:
            [loadingView dismiss];
            [delegate performSelector:@selector(fresh)];
            [[[MMFloatingNotification alloc] initWithTitle:MSG_LOGIN_SUCCESSFUL] show:self.view.superview];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case PW_INCORRECT:
            [loadingView performSelector:@selector(dismissWithMessage:) withObject:MSG_INCORRECT_PW afterDelay:0.5f];
            break;
        case UNEXIST:
            [loadingView performSelector:@selector(dismissWithMessage:) withObject:MSG_UNEXIST_USER afterDelay:0.5f];
            break;
        case ERROR:
        default:
            [loadingView performSelector:@selector(dismissWithMessage:) withObject:MSG_UNKNOWN_ERROR afterDelay:0.5f];
            break;
    }
    
}

- (IBAction)btnBack:(id)sender {
    [delegate performSelector:@selector(fresh)];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidUnload {
    [self setTxtUserName:nil];
    [self setTxtPassWord:nil];
    [super viewDidUnload];
}
@end
