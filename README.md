# FMDBHelper
`FMDBHelper` 是FMDB数据库操作的助手类, FMDB封装了sqlite的底层操作, 让数据库操作变得更加的简便, FMDBHelper是对FMDB的二次开发, 提供了面向对象的操作数据库的方法, `增删改查` 都只需要一行代码就可以实现, 并且使用时候不涉及sql语句的编写.

### 这个工具类包含两部分
* AssignToObject : 顾名思义, 给对象赋值, 这个类使用runtime的技术, 一方面是FMDBHelper的工具类, 另一方面在其它场景也有很广泛的应用, 详见下文.
* FMDBHelper : FMDB助手类, 这个类提供对象对象的数据库操作的方式, 让数据库操作更加的简单.

#### AssignToObject

```
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
+ (id)customObject:(NSString *)model fromDictionary:(NSDictionary *)dict;

@end
```

#### FMDBHelper

##### pragma mark 推荐使用以下的方法进行数据库操作, 以下方法包含了所有FMDBHelper的方法
** NSObject的分类, 可以直接调用通过model对象调用相应的方法, 插入更新数据. **

**推荐使用model的类方法或者实例方法直接增删改查数据库数据.**

```

@interface NSObject (FMDBHelper)

 #pragma mark - 插入记录
- (BOOL)insertRecord;

 #pragma mark - 删除记录
// 删除数据库表中对应数据库类名所有的数据
+ (void)deleteDataBaseTable;
// 根据对象, 删除其在数据库中的记录
- (void)deleteRecord;
// 删除对象的指定属性, 指定值得数据库行
+ (void)deleteRecordWithKeyProperty:(NSString *)property andKeyValue:(id)value;
// 根据对象keyProperty删除记录
- (void)deleteRecordWithKeyProperty:(NSString *)property;
// 根据对象属性删除记录


 #pragma mark - 修改记录
- (void)updateRecordWithKeyProperty:(NSString *)keyProperty;

 #pragma mark - 查找记录
+ (NSMutableArray *)getAllRecod;
+ (NSMutableArray *)getRecordWithKeyProperty:(NSString *)property keyValue:(id)value;

@end

@interface NSMutableArray (FMDBHelper)

 #pragma mark - 插入记录
- (BOOL)insertRecord;

@end
```

``` 
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
+ (void)deleteReCordWithTableName:(NSString *)tableName andKeyProperty:(NSString *)property andKeyValue:(id)value;
+ (void)deleteRecordWithModel:(id)model andKeyProperty:(NSString *)property;

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
```

### FMDB使用示例
1, 向数据库中插入一条model数据

```
/// 根据实例对象插入一条记录
[model insertRecord];
/// 插入数组中所有数据到数据库中, 可以是不同的对象
[arr insertRecordFromArray];
```
2, 从数据库中删除数据

```
/// 删除数据库表中对应数据库类名所有的数据
[model deleteRecord];
/// 根据对象, 删除其在数据库中的记录
[model deleteRecordWithKeyProperty:@"name"];
/// 删除对象的指定属性, 指定值得数据库行
[DataModel deleteDataBaseTable];
/// 根据对象keyProperty删除记录
[DataModel deleteRecordWithKeyProperty:@"name" andKeyValue:@"小明"];
```
3, 更新model中的数据

```
/// 修改数据库中数据
// keyProperty作用是找到对应的记录
[model updateRecordWithKeyProperty:@"name"];
```
4, 从数据库中查找数据

```
/// 获取对象名字在数据库中所有记录
NSArray *arr2 = [DataModel getAllRecod];
/// 根据keyProperty和keyvalue获取指定的记录
NSArray *arr3 = [DataModel getRecordWithKeyProperty:@"name" keyValue:@"小明"];
```




