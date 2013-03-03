//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender;
@end 

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>{
    
}

@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
@property(nonatomic) NSInteger selectedRow;
@property(nonatomic) BOOL isDropped;

-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b height:(CGFloat *)height names:(NSArray *)arr;
- (id)showDropUp:(UIButton *)b height:(CGFloat *)height names:(NSArray *)arr;
@end
