//
//  AssignToObject.h
//  SQ
//
//  Created by len on 15/10/6.
//  Copyright (c) 2015年 walden. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;

@interface AssignToObject : NSObject

//1,根据类名获得属性列表
+ (id)propertyKeysFromString:(NSString *)classStr;

//2,根据数据库表查到的一行数据，和表名，创建一个model对象
+ (id)reflectDataFromOtherObject:(FMResultSet *)dataSource andObjectStr:(NSString *)classStr;

//3,根据model对象名字和数组名字，返回一个包含n个model对象的数组
+ (NSMutableArray *)customModel:(NSString *)modelClass fromArray:(NSArray *)arr;

//4，将一个Model转换成对应键值的字典
+ (NSDictionary *)dictionaryWithObject:(id)model;

//5，字典转换成Model
+ (id)customObject:(NSString *)classStr fromDictionary:(NSDictionary *)dict;


@end
