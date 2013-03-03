//
//  XYLoadingView.m
//
//  Created by Samuel Liu on 7/25/12.
//  Copyright (c) 2012 Telenavsoftware. All rights reserved.
//

#import "XYLoadingView.h"

@implementation XYLoadingView

@synthesize message = _message;
@synthesize isLoading;
+(id)loadingViewWithMessage:(NSString *)message
{
    return [[XYLoadingView alloc] initWithMessaege:message];
}

-(id)initWithMessaege:(NSString *)message
{
    self = [self init];
    if(self)
    {
        self.message = message;
        self.isLoading = YES;
    }
    return self;
}

-(void)show
{
    [[XYAlertViewManager sharedAlertViewManager] show:self];
}

-(void)dismiss
{
    [[XYAlertViewManager sharedAlertViewManager] dismiss:self];
}

-(void)dismissWithMessage:(NSString*)message
{
    [[XYAlertViewManager sharedAlertViewManager] dismissLoadingView:self withFailedMessage:message];
}
-(void)dismissWithSuceessfulMessage:(NSString*)message{
    [[XYAlertViewManager sharedAlertViewManager] dismissLoadingView:self withSuccessfulMessage:message];

}
@end
