//
//  FMDBHelper.h
//  FMDBHelper
//
//  Created by Walden on 16/2/19.
//  Copyright © 2016年 Walden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface FMDBHelper : NSObject

#pragma mark - 基础的方法
// 1, 数据库工具类的单例
+ (id)shareHelper;

//2，判断表中是否有多个对应的属性和值
+ (BOOL)isExistTable:(NSString *)tableName andObject:(id)object andObjectPropertys:(NSString *)propertyName, ... NS_REQUIRES_NIL_TERMINATION;

//3，判断是否有对应的表, 表中是否有值与参数给出对象完全相等
+ (BOOL)isExistTable:(NSString *)tableName andObject:(id)object;


#pragma mark - 插入记录
//4, 像数据库中插入一个Model
+ (BOOL)insertRecordWithTableName:(NSString *)tableName andModel:(id)object;

//5, 以model数组的形式请求插入用户数据
+ (BOOL)insertRecordWithTableName:(NSString *)tableName andModelArray:(NSArray *)arr;


#pragma mark - 删除记录
//6, 删除记录 删除某个属性等于某个值得一个记录   比如  id = 100
+ (void)deleteRecordWithTableName:(NSString *)tableName andKeyProperty:(NSString *)property andKeyValue:(id)value;

//7, 删除一个表中所有信息
+ (void)deleteReCordWithTableName:(NSString *)tableName;


#pragma mark - 修改记录
//8, 修改记录
+ (void)updateRecordWithObject:(id)obj andKeyProperty:(NSString *)keyProperty;


#pragma mark - 查找记录
//9, 根据数据库的表名称 查询数据库表中所有的数据对象
+ (NSMutableArray *)getAllRecod:(NSString *)tableName;
//10, 根据表名 和 key value, 查找对应的数据
+ (NSMutableArray *)getRecordWithTableName:(NSString *)tableName keyProperty:(NSString *)property keyValue:(id)value;

@end
