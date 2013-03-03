//
//  classTableDataModel.m
//  iQSC
//
//  Created by zy on 13-1-31.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import "classTableDataModel.h"

@implementation classTableDataModel
@synthesize semester,course_id_md5,_id,name,place,teacher,time;
-(classTableDataModel *)initWithJson:(NSDictionary *)json{
    if (self = [super init]) {
        self._id = [json valueForKey:@"id"];
        self.course_id_md5 = [json valueForKey:@"hash"];
        self.name = [json valueForKey:@"name"];
        self.semester = [json valueForKey:@"semester"];
        self.time = [json valueForKey:@"current_time"];
        self.place = [json valueForKey:@"place"];
        self.teacher = [json valueForKey:@"teacher"];
    }
    return  self;
}
@end
