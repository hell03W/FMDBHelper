//
//  ViewController.m
//  FMDBHelper
//
//  Created by Walden on 16/2/19.
//  Copyright © 2016年 Walden. All rights reserved.
//

#import "ViewController.h"
#import "FMDBHelper.h"
#import "DataModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@", NSHomeDirectory());
    
    [self testFMDB];
}

- (void)testFMDB
{
    DataModel *model = [[DataModel alloc] init];
    
    //1. 数据库插入数据
    [model insertRecord];
    NSArray *arr = @[model, model, model];
    [arr insertRecordFromArray];
    
    //2. 更新数据库中数据
    [model updateRecordWithKeyProperty:@"name"];
    
    //3. 删除数据库中数据
    [model deleteRecord];
    [model deleteRecordWithKeyProperty:@"name"];
    [DataModel deleteDataBaseTable];
    [DataModel deleteRecordWithKeyProperty:@"name" andKeyValue:@"小明"];
    
    //4. 查找数据库中数据
    /// 获取对象名字在数据库中所有记录
    NSArray *arr2 = [DataModel getAllRecod];
    /// 根据keyProperty和keyvalue获取指定的记录
    NSArray *arr3 = [DataModel getRecordWithKeyProperty:@"name" keyValue:@"小明"];
    
    //1, 向数据库中插入数据
//    [FMDBHelper insertRecordWithModel:model];
//    [FMDBHelper insertRecordWithModelArray:@[model, model]];
    
    //2, 从数据库中删除数据
//    [FMDBHelper deleteReCordWithTableName:@"DataModel" andKeyProperty:@"primedId" andKeyValue:@2];
//    [FMDBHelper deleteRecordWithModel:model andKeyProperty:@"name"];
//    [FMDBHelper deleteReCordWithTableName:@"DataModel"];
    
    //3, 更新数据
//    model.name = @"WHealer";
//    model.title = @"My Girl";
//    model.sex = @"girl";
//    [FMDBHelper insertRecordWithTableName:@"DataModel" andModel:model];
//    [FMDBHelper updateRecordWithObject:model andKeyProperty:@"name"];

    //4, 查找数据
//    NSArray *alldata = [FMDBHelper getAllRecod:@"DataModel"];
//    NSArray *someData = [FMDBHelper getRecordWithTableName:@"DataModel" keyProperty:@"name" keyValue:@2];
    
//    [model deleteRecord];
    
//    alldata = [FMDBHelper getAllRecod:@"DataModel"];
    
    
//    NSLog(@"%@", someData);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
