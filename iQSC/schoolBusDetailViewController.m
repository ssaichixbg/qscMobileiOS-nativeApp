//
//  schoolBusDetailViewController.m
//  iQSC
//
//  Created by zy on 13-2-4.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "schoolBusDetailViewController.h"

@interface schoolBusDetailViewController ()

@end

@implementation schoolBusDetailViewController
@synthesize lblBz,lblCh,lblEndTime,lblStartTime,lblTkdd,lblYxsj,delegate,_schoolBus;
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
    lblCh.text = _schoolBus.ch;
    lblYxsj.text = _schoolBus.yxsj;
    lblTkdd.text = _schoolBus.tkdd;
    lblBz.text = _schoolBus.bz;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"H:mm";
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CCT"];
    lblStartTime.text = [formatter stringFromDate:_schoolBus.fcsj];
    lblEndTime.text = [formatter stringFromDate:_schoolBus.dzsj];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblCh:nil];
    [self setLblStartTime:nil];
    [self setLblEndTime:nil];
    [self setLblYxsj:nil];
    [self setLblTkdd:nil];
    [self setLblBz:nil];
    [super viewDidUnload];
}
@end
