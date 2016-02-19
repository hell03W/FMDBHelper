//
//  TableViewDataModel.m
//  TableViewDemo
//
//  Created by  www.6dao.cc on 15/12/15.
//  Copyright © 2015年 www.6dao.com. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (instancetype)init
{
    if (self = [super init]) {
        _name = @"walden";
        _sex = @"mae";
        _title = @"TestDataModel";
        _content = @"just a test";
    }
    return self;
}

@end
