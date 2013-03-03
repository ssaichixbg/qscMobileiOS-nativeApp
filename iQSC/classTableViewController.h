//
//  classTableViewController.h
//  iQSC
//
//  Created by zy on 13-2-6.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHeader.h"
#import "coreUserHeader.h"
#import "corePublicHeader.h"

@interface classTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnTermType;
- (IBAction)stepperDay:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segWeekType;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnFresh;
- (IBAction)segWeekType:(id)sender;
- (IBAction)btnFresh:(id)sender;
- (IBAction)btnTermType:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

-(void)fresh;
-(void)startToFreshFromServer;
-(void)freshingFromServer;
-(void)endFreshing;
@end
