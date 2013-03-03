//
//  schoolBusQuerryViewController.h
//  iQSC
//
//  Created by zy on 13-2-3.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHeader.h"
#import "corePublicHeader.h"
@interface schoolBusQuerryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnSelectStart;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectEnd;
@property (weak, nonatomic) IBOutlet UITableView *busTableView;
- (IBAction)pressSelectBtn:(id)sender;
- (IBAction)btnFresh:(id)sender;
- (void)fresh;
-(void)startToFreshFromServer;
-(void)freshingFromServer;
-(void)endFreshing;
@end
