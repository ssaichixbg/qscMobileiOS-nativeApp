//
//  lauchCartoonViewController.m
//  iQSC
//
//  Created by zy on 13-1-30.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "lauchCartoonViewController.h"

@interface lauchCartoonViewController ()

@end

@implementation lauchCartoonViewController

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
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    //cartoon
    UIImageView *splashView;
    if(iPhone5){
        splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 568)];
        splashView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    }
    else{
        splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
        splashView.image = [UIImage imageNamed:@"Default@2x.png"];
    }
    [self.view addSubview:splashView];
    [self.view bringSubviewToFront:splashView];
    /*[UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:0.8];
     [UIView setAnimationTransition:UIViewAnimationTransitionNone forView: self.view cache:YES];
     [UIView setAnimationDelegate:self];
     [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
     splashView.alpha = 0.0;
     splashView.frame = CGRectMake(-60, -85, 440, 635);
     [UIView commitAnimations];*/
}
- (void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [self performSegueWithIdentifier:@"gotoMainView" sender:self];
    //sleep(1);
    //status bar

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
