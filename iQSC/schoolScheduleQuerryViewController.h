//
//  schoolScheduleQuerryViewController.h
//  iQSC
//
//  Created by zy on 13-2-3.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHeader.h"
#import "corePublicHeader.h"
@interface schoolScheduleQuerryViewController : UITableViewController<SRRefreshDelegate,UITableViewDelegate>{
    
}
- (IBAction)btnFresh:(id)sender;
- (void)fresh;
-(void)startToFreshFromServer;
-(void)freshingFromServer;
-(void)endFreshing;
@end
