//
//  currentDateDataModel.h
//  iQSC
//
//  Created by zy on 13-2-3.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dateTypeDataModel : NSObject{
    BOOL isOdd;
    enum periodType{
        springTerm,
        summerTerm,
        autumnTerm,
        winterTerm,
        summerVacation,
        winterVacation
    }periodType;
}
@property(nonatomic) BOOL isOdd;
@property(nonatomic) enum periodType periodType;
@end
