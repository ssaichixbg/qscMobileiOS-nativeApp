//
//  examDetialViewController.m
//  iQSC
//
//  Created by zy on 13-1-31.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "examDetialViewController.h"

@interface examDetialViewController ()

@end

@implementation examDetialViewController
@synthesize delegate,_exam,lblCoueseName,lblCXBJ,lblPlace,lblSeatIndex,lblTime,lblXuefen;
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
    if (_exam) {
        lblCoueseName.text = _exam.kcmc;
        lblTime.text = _exam.kssj;
        lblXuefen.text =[NSString stringWithFormat:@"学分：%@", _exam.xf];
        //NSLog(@"%d",[_exam.ksdd length]);
        if ([_exam.ksdd isEqualToString:@" "]) lblPlace.text = @"地点：待定";
        else lblPlace.text = _exam.ksdd;
        if ([_exam.kszwh isEqualToString:@" "]) lblSeatIndex.text = @"考试座位：待定";
        else lblSeatIndex.text = [NSString stringWithFormat:@"考试座位：%@",_exam.kszwh];
        if ([_exam.cxbj isEqualToString:@" "]) lblCXBJ.text = @"重修标记：否";
        else lblCXBJ.text = [NSString stringWithFormat:@"重修标记：%@",_exam.cxbj];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblCoueseName:nil];
    [self setLblTime:nil];
    [self setLblXuefen:nil];
    [self setLblPlace:nil];
    [self setLblSeatIndex:nil];
    [self setLblCXBJ:nil];
    [super viewDidUnload];
}
@end
