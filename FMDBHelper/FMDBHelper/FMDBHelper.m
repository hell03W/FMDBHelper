//
//  FMDBHelper.m
//  FMDBHelper
//
//  Created by Walden on 16/2/19.
//  Copyright © 2016年 Walden. All rights reserved.
//

#import "FMDBHelper.h"
#import "AssignToObject.h"
#import <stdarg.h>

@interface FMDBHelper ()

@property (nonatomic, strong)FMDatabase *fmdb;
@property (nonatomic, strong)FMResultSet *fmrs;

@end

@implementation FMDBHelper
@synthesize fmdb, fmrs;

static FMDBHelper *fmdbHelper;

// 1, 数据库工具类的单例
+ (id)shareHelper
{
    if (!fmdbHelper) {
        @synchronized(self)
        {
            if (!fmdbHelper) {
                fmdbHelper = [[FMDBHelper alloc] init];
                NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/FMDBHelper.db"];
                fmdbHelper.fmdb = [FMDatabase databaseWithPath:path];
                if (![fmdbHelper.fmdb open]) {
                    NSLog(@"创建数据库失败");
                    fmdbHelper = nil;
                }
            }
        }
    }
    return fmdbHelper;
}

// 判断数据库表是否存在
- (BOOL)isTableExist:(NSString *)tableName
{
    BOOL isExist = NO;
    if ([fmdb tableExists:tableName]) {
        NSLog(@"====table存在====");
        isExist = YES;
    }
    return isExist;
}

// 创建表格，自动添加ID作为主键
- (void)createTable:(NSString *)tableName //tableName必须和模型名称相同
{
    //如果表已经存在，则停止创建
    if ([self isTableExist:tableName]) {
        return;
    }
    NSMutableString *sqlString = [NSMutableString string];
    [sqlString appendString:[NSString stringWithFormat:@"CREATE TABLE %@ ", tableName]];
    [sqlString appendString:@"("];
    
    NSArray *propertyArray = [AssignToObject propertyKeysFromString:tableName];
    for (NSString *propertyName in propertyArray) {
        [sqlString appendString:propertyName];
        [sqlString appendString:@", "];
    }
    
    [sqlString appendString:@"primaryId integer primary key autoincrement"];
    [sqlString appendString:@")"];
    NSLog(@"sqlString = %@", sqlString);
    
    [fmdb executeUpdate:sqlString];
}

//2，判断表中是否有多个对应的属性和值
+ (BOOL)isExistTable:(NSString *)tableName andObject:(id)object andObjectPropertys:(NSString *)propertyName, ... NS_REQUIRES_NIL_TERMINATION
{
    BOOL value = NO;
    FMDBHelper *helper = [FMDBHelper shareHelper];
    
    //1，将可变参数的属性名字放到一个可变数组中
    NSMutableArray *mutableArray = [NSMutableArray array];
    va_list varList;
    id temp;
    va_start(varList, propertyName);
    while ((temp = va_arg(varList, NSString *)) != nil)
    {
        NSLog(@"%@", temp);
        [mutableArray addObject:temp];
    }
    va_end(varList);//6，关闭varList指针
    
    //2,拼接字符串
    NSMutableString *sqlString = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE ", tableName];
    NSMutableArray *propertyArray = [NSMutableArray array];
    //2.1,执行for循环，1）拼接出字符串；2）构建出属性数组
    for (NSString *propertyName in mutableArray)
    {
        [sqlString appendFormat:@" %@ = ? AND", propertyName];
        [propertyArray addObject:[object valueForKey:propertyName]];
    }
    [sqlString deleteCharactersInRange:NSMakeRange(sqlString.length-3, 3)];
    
    [helper.fmdb executeQuery:sqlString withArgumentsInArray:propertyArray];
    if ([helper.fmrs next]) {
        value = YES;
    }
    return value;
}

//3，判断是否有对应的表, 表中是否有值与参数给出对象完全相等
+ (BOOL)isExistTable:(NSString *)tableName andObject:(id)object
{
    BOOL value = NO;
    FMDBHelper *helper = [FMDBHelper shareHelper];

    //1, 获取属性的名字和值
    NSDictionary *dict = [AssignToObject dictionaryWithObject:object];
    NSArray *keys = [dict allKeys];
    NSArray *values = [dict allValues];
    
    //2,拼接字符串
    NSMutableString *sqlString = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE ", tableName];
    for (NSString *propertyName in keys)
    {
        [sqlString appendFormat:@" %@ = ? AND", propertyName];
    }
    [sqlString deleteCharactersInRange:NSMakeRange(sqlString.length-3, 3)];
    
    [helper.fmdb executeQuery:sqlString withArgumentsInArray:values];
    if ([helper.fmrs next]) {
        value = YES;
    }
    return value;
}


#pragma mark - 插入记录
//4, 像数据库中插入一个Model
+ (BOOL)insertRecordWithTableName:(NSString *)tableName andModel:(id)object
{
    BOOL value = NO;
    FMDBHelper *helper = [FMDBHelper shareHelper];
    
    //如果表不存在则先创建表
    if (![helper isTableExist:tableName]) {
        [helper createTable:tableName];
    }
    
    //1, 获取属性的名字和值
    NSDictionary *dict = [AssignToObject dictionaryWithObject:object];
    NSArray *keys = [dict allKeys];
    NSArray *values = [dict allValues];
    
    //2, 拼字符串
    NSMutableString *sqlString = [NSMutableString string];
    [sqlString appendString:[NSString stringWithFormat:@"INSERT INTO %@ ", tableName]];
    [sqlString appendString:@"("];
    
    for (NSString *key in keys)
    {
        [sqlString appendString:key];
        [sqlString appendString:@", "];
    }
    [sqlString deleteCharactersInRange:NSMakeRange(sqlString.length-2, 2)];
    [sqlString appendString:@") VALUES ("];
    
    for (int i = 0; i < [keys count]; i++)
    {
        [sqlString appendString:@"?, "];
    }
    [sqlString deleteCharactersInRange:NSMakeRange(sqlString.length-2, 2)];
    [sqlString appendString:@")"];
    
    if ([helper.fmdb executeUpdate:sqlString withArgumentsInArray:values])
    {
        value = YES;
    }
    return value;;
}

//5, 以model数组的形式请求插入用户数据
+ (BOOL)insertRecordWithTableName:(NSString *)tableName andModelArray:(NSArray *)arr
{
    BOOL value = NO;
    FMDBHelper *helper = [FMDBHelper shareHelper];
    [helper.fmdb beginTransaction]; //开启事务
    
    for (id object in arr) {
        value = [FMDBHelper insertRecordWithTableName:tableName andModel:object];
    }
    
    [helper.fmdb commit]; //终止事务
    return YES;
}

#pragma mark - 删除记录
//6, 删除记录 删除某个属性等于某个值得一个记录   比如  id = 100
+ (void)deleteRecordWithTableName:(NSString *)tableName andKeyProperty:(NSString *)property andKeyValue:(id)value
{
    FMDBHelper *helper = [FMDBHelper shareHelper];
    
    NSMutableString *sqlString = [NSMutableString string];
    
    [sqlString appendString:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", tableName, property]];
    
    [helper.fmdb executeUpdate:sqlString withArgumentsInArray:[NSArray arrayWithObject:value]];
}

//7, 删除一个表中所有信息
+ (void)deleteReCordWithTableName:(NSString *)tableName
{
    FMDBHelper *helper = [FMDBHelper shareHelper];
    
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    
    [helper.fmdb executeUpdate:sqlString];
}

#pragma mark - 修改记录
//8, 修改记录
+ (void)updateRecordWithObject:(id)obj andKeyProperty:(NSString *)keyProperty
{
    FMDBHelper *helper = [FMDBHelper shareHelper];
    NSDictionary *dict = [AssignToObject dictionaryWithObject:obj];
    NSArray *keys = [dict allKeys];
    NSArray *values = [dict allValues];

    NSMutableString *sqlString = [NSMutableString string];
    [sqlString appendString:[NSString stringWithFormat:@"UPDATE %@ SET ",NSStringFromClass([obj class])]];

    for (int i = 0; i < keys.count; i++)
    {
        [sqlString appendString:[keys objectAtIndex:i]];
        [sqlString appendString:@" = ?, "];
        
    }
    [sqlString deleteCharactersInRange:NSMakeRange([sqlString length] - 2, 2)];
    
    [sqlString appendString:@" WHERE "];
    
    [sqlString appendFormat:@"%@ = '%@' ", keyProperty, [dict objectForKey:keyProperty]];
    
    [helper.fmdb executeUpdate:sqlString withArgumentsInArray:values];
}

#pragma mark - 获取记录
// 根据数据库的表名称 查询数据库表中所有的数据对象
+ (NSMutableArray *)getAllRecod:(NSString *)tableName
{
    FMDBHelper *helper = [FMDBHelper shareHelper];
    NSMutableArray *returnArray = [NSMutableArray array];

    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    helper.fmrs = [helper.fmdb executeQuery:sqlString];
    
    while ([helper.fmrs next])
    {
        id user = [AssignToObject reflectDataFromOtherObject:helper.fmrs
                                                andObjectStr:tableName];
        [returnArray addObject:user];
    }
    return returnArray;
}

// 根据表名 和 key value, 查找对应的数据
+ (NSMutableArray *)getRecordWithTableName:(NSString *)tableName keyProperty:(NSString *)property keyValue:(id)value
{
    FMDBHelper *helper = [FMDBHelper shareHelper];
    NSMutableArray *returnArray = [NSMutableArray array];
    
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' ",tableName, property, value];
    helper.fmrs = [helper.fmdb executeQuery:sqlString];
    
    while ([helper.fmrs next])
    {
        id user = [AssignToObject reflectDataFromOtherObject:helper.fmrs
                                                andObjectStr:tableName];
        [returnArray addObject:user];
    }
    return returnArray;
}


@end






















