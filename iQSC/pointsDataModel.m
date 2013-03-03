//
//  pointsDataModel.m
//  iQSC
//
//  Created by zy on 13-1-31.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "pointsDataModel.h"

@implementation pointsDataModel
@synthesize jd,jj,bkcj,kcmc,dataType,xf,xkkh,cj,isNew,sj,zxf;
-(NSDictionary *)returnDic{
    NSDictionary *dic = nil;
    switch (self.dataType) {
        case GPA:
            
            break;
        case singleCoursePoint:
            
            break;
        default:
            break;
    }
    return dic;
}
//选课课号，课程名称，成绩，学分，绩点，补考成绩
-(pointsDataModel *)initWithSingleCourseJson:(NSDictionary *)json{
    if (self = [super init]) {
        self.dataType = singleCoursePoint;
        self.xkkh = [json valueForKey:@"选课课号"];
        self.kcmc = [json valueForKey:@"课程名称"];
        self.cj= [json valueForKey:@"成绩"];
        self.xf = [json valueForKey:@"学分"];
        self.jd = [json valueForKey:@"绩点"];
        self.bkcj = [json valueForKey:@"补考成绩"];
    }
    return  self;
}
//总学分，均绩，时间
-(pointsDataModel *)initWithGPAJson:(NSDictionary *)json{
    if (self = [super init]) {
        self.dataType = GPA;
        self.zxf = [json valueForKey:@"总学分"];
        self.jj = [json valueForKey:@"均绩"];
        self.sj = [json valueForKey:@"时间"];
    }
    return  self;
}
@end
