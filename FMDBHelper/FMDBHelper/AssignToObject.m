//
//  AssignToObject.m
//  SQ
//
//  Created by len on 15/10/6.
//  Copyright (c) 2015年 wangze. All rights reserved.
//

#import "AssignToObject.h"
#import "FMDatabase.h"
#import <objc/runtime.h>

@implementation AssignToObject

//1，根据类名获得属性列表
+ (id)propertyKeysFromString:(NSString *)classStr
{
    const char *str = [classStr UTF8String];
    id Model = objc_getClass(str);
    unsigned int outcount;
    objc_property_t *propertys = class_copyPropertyList(Model, &outcount);
    
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i < outcount; i++) {
        objc_property_t property = propertys[i];
        NSString *propertyStr = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyStr];
    }
    
    return keys;
}

//2,用字典为类的各个属性赋值
+ (id)reflectDataFromOtherObject:(FMResultSet *)dataSource andObjectStr:(NSString *)classStr

{
    id model = [[NSClassFromString(classStr) alloc] init];
    
    for (NSString *key in [self propertyKeysFromString:classStr])
    {
        id propertyValue = [dataSource stringForColumn:key];
        
        //该值不为NSNULL，并且也不为nil
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue != nil)
        {
            //为对象的各个属性赋值
            [model setValue:propertyValue forKey:key];
        }
    }
    
    return model;
}

//3,将数组中的内容存储到model对象中去
+ (NSMutableArray *)customModel:(NSString *)model fromArray:(NSArray *)arr
{
    //获取类名
    const char *name = [model UTF8String];
    id modelClass = objc_getClass(name);
    //获取属性列表和属性个数
    unsigned int outCount;
    objc_property_t *propertys = class_copyPropertyList(modelClass, &outCount);
    
    NSMutableArray *modelArr = [NSMutableArray arrayWithCapacity:1];
    //循环遍历有多少个model对象
    for (id dict in arr) {
        if (![dict isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        id model = [[modelClass alloc] init];
        for (int i = 0; i < outCount; i++) {
            NSString *propertyName = [NSString stringWithCString:property_getName(propertys[i]) encoding:NSUTF8StringEncoding];
            id value = [dict objectForKey:propertyName];
            if (!value || [value isKindOfClass:[NSNull class]]) {
                continue;
            }
            [model setValue:value forKey:propertyName];
        }
        [modelArr addObject:model];
    }
    
    return modelArr;
}

//4，将一个Model转换成对应键值的字典
+ (NSDictionary *)dictionaryWithObject:(id)model
{
    NSArray *allKeys = [self propertyKeysFromString:[NSString stringWithUTF8String:object_getClassName(model)]];
    
    NSMutableArray *allValues = [NSMutableArray array];
    for (NSString *key in allKeys)
    {
        [allValues addObject:[model valueForKey:key]];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:allValues forKeys:allKeys];
    
    return dict;
}

//5，字典转换成Model
+ (id)customModel:(NSString *)model fromDictionary:(NSDictionary *)dict
{
    return [[self customModel:model fromArray:[NSArray arrayWithObject:dict]] firstObject];
}


@end
