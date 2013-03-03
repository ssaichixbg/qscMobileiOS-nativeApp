//
//  examDetialViewController.h
//  iQSC
//
//  Created by zy on 13-1-31.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHeader.h"
#import "coreUserHeader.h"
@interface examDetialViewController : UIViewController{
    
}
@property (nonatomic,strong) id delegate;
@property (nonatomic,strong) examsDataModel *_exam;
@property (weak, nonatomic) IBOutlet UILabel *lblXuefen;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblCoueseName;
@property (weak, nonatomic) IBOutlet UILabel *lblPlace;
@property (weak, nonatomic) IBOutlet UILabel *lblSeatIndex;
@property (weak, nonatomic) IBOutlet UILabel *lblCXBJ;
@end
