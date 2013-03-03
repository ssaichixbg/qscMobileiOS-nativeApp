//
//  pointsDataModel.h
//  iQSC
//
//  Created by zy on 13-1-31.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pointsDataModel : NSObject{
    //选课课号，课程名称，成绩，学分，绩点，补考成绩
    NSString *xkkh,*kcmc,*cj,*cf,*jd,*bkcj;
    BOOL isNew;
    //总学分，均绩，时间
    NSString *zxf,*jj,*sj;
    enum pointType {
        singleCoursePoint,
        GPA
    }dataType;

}
@property (nonatomic,copy) NSString* xkkh;
@property (nonatomic,copy) NSString* kcmc;
@property (nonatomic,copy) NSString* cj;
@property (nonatomic,copy) NSString* xf;
@property (nonatomic,copy) NSString* jd;
@property (nonatomic,copy) NSString* bkcj;
@property (nonatomic) BOOL isNew;
@property (nonatomic,copy) NSString* zxf;
@property (nonatomic,copy) NSString* jj;
@property (nonatomic,copy) NSString* sj;
@property (nonatomic) enum pointType dataType;

-(NSDictionary *)returnDic;
-(pointsDataModel *)initWithSingleCourseJson:(NSDictionary *)json;
-(pointsDataModel *)initWithGPAJson:(NSDictionary *)json;
@end
