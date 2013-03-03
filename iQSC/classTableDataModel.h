//
//  classTableDataModel.h
//  iQSC
//
//  Created by zy on 13-1-31.
//  Copyright (c) 2013年 myqsc. All rights reserved.
//

#import <Foundation/Foundation.h>
/*"id": "211G0060",
 "name": "大学计算机基础",
 "teacher": "陈建海",
 "semester": "秋冬",
 "hash": "15c56f3c10af0ab6f3c20a519886805e",
 "class": [
 {
 "week": "both",
 "weekday": "3",
 "place": "紫金港东1A-301(多)",
 "class": [
 "1",
 "2"
 ]
 },
 {
 "week": "odd",
 "weekday": "4",
 "place": "紫金港机房",
 "class": [
 "3",
 "4"
 ]
 }
 ]*/
@interface classTableDataModel : NSObject{
    NSString  *_id,*name,*teacher,*semester,*course_id_md5,*place;
    NSArray *time;
}
@property (nonatomic,copy) NSString *_id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *teacher;
@property (nonatomic,copy) NSString *semester;
@property (nonatomic,copy) NSString *course_id_md5;
@property (nonatomic,copy) NSString *place;
@property (nonatomic,copy) NSArray *time;

-(classTableDataModel *)initWithJson:(NSDictionary *)json;
@end
