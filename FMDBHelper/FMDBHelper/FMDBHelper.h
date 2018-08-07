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
+ (BOOL)insertRecordWithModel:(id)object;

//5, 以model数组的形式请求插入用户数据
+ (BOOL)insertRecordWithModelArray:(NSArray *)arr;


#pragma mark - 删除记录
//6, 删除记录 删除某个属性等于某个值得一个记录   比如  id = 100
+ (void)delRecordWithTableName:(NSString *)tableName andKeyProperty:(NSString *)property andKeyValue:(id)value;
+ (void)delRecordWithModel:(id)model;
+ (void)delRecordWithModel:(id)model andKeyProperty:(NSString *)property;

//7, 删除一个表中所有信息
+ (void)delRecordWithTableName:(NSString *)tableName;


#pragma mark - 修改记录
//8, 修改记录
+ (void)updateRecordWithObject:(id)obj andKeyProperty:(NSString *)keyProperty;


#pragma mark - 查找记录
//9, 根据数据库的表名称 查询数据库表中所有的数据对象
+ (NSMutableArray *)getAllRecod:(NSString *)tableName;

//10, 根据表名 和 key value, 查找对应的数据
+ (NSMutableArray *)getRecordWithTableName:(NSString *)tableName keyProperty:(NSString *)property keyValue:(id)value;

@end



#pragma mark 推荐使用以下的方法进行数据库操作, 以下方法包含了所有FMDBHelper的方法
// NSObject的分类, 可以直接调用通过model对象调用相应的方法, 插入更新数据
@interface NSObject (FMDBHelper)

#pragma mark - 插入记录
/// 根据实例对象插入一条记录
- (BOOL)insertRecord;

#pragma mark - 删除记录
/// 删除数据库表中对应数据库类名所有的数据
+ (void)delDataBaseTable;
/// 根据对象, 删除其在数据库中的记录
- (void)delRecord;
/// 删除对象的指定属性, 指定值得数据库行
+ (void)delRecordWithKeyProperty:(NSString *)property andKeyValue:(id)value;
/// 根据对象keyProperty删除记录
- (void)delRecordWithKeyProperty:(NSString *)property;


#pragma mark - 修改记录
/// 修改数据库中数据
// keyProperty作用是找到对应的记录
- (void)updateRecordWithKeyProperty:(NSString *)keyProperty;

#pragma mark - 查找记录
/// 获取对象名字在数据库中所有记录
+ (NSMutableArray *)getAllRecod;
/// 根据keyProperty和keyvalue获取指定的记录
+ (NSMutableArray *)getRecordWithKeyProperty:(NSString *)property keyValue:(id)value;

@end

@interface NSArray (FMDBHelper)

#pragma mark - 插入记录
/// 插入数组中所有数据到数据库中, 可以是不同的对象
- (BOOL)insertRecordFromArray;

@end








#pragma mark - 对FMDataBase加密, 使用 SQLCipher, 通过重载方法 实现加密
@interface FMCipherDataBase : FMDatabase

+ (instancetype)databaseWithPath:(NSString *)inPath cipherKey:(NSString *)cipherKey;

@end



