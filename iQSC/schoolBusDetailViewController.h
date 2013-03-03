//
//  schoolBusDetailViewController.h
//  iQSC
//
//  Created by zy on 13-2-4.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "corePublicHeader.h"
#import "UIHeader.h"
@interface schoolBusDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblBz;
@property (weak, nonatomic) IBOutlet UILabel *lblTkdd;
@property (weak, nonatomic) IBOutlet UILabel *lblYxsj;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;
@property (weak, nonatomic) IBOutlet UILabel *lblCh;
@property (weak, nonatomic) IBOutlet UILabel *lblStartTime;
@property(nonatomic,strong)id delegate;
@property(nonatomic,strong)schoolBusDataModel *_schoolBus;
@end
