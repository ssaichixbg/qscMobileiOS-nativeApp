//
//  pointsListViewController.h
//  iQSC
//
//  Created by zy on 13-1-31.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHeader.h"
#import "coreUserHeader.h"
@interface pointsListViewController : UITableViewController
<UITableViewDelegate, SRRefreshDelegate>{
   
}
- (IBAction)btnFresh:(id)sender;
-(void)fresh;
-(void)startToFreshFromServer;
-(void)freshingFromServer;
-(void)endFreshing;
@end
