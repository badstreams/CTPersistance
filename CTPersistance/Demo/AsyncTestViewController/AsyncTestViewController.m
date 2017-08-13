//
//  AsyncTestViewController.m
//  CTPersistance
//
//  Created by casa on 2017/8/12.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "AsyncTestViewController.h"
#import "CTPersistanceAsyncExecutor.h"

#import "TestTable.h"
#import "TestRecord.h"

@interface AsyncTestViewController ()

@property (nonatomic, strong) TestTable *testTable;

@end

@implementation AsyncTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSInteger count = 100;
    while (count --> 0) {
        TestRecord *record = [[TestRecord alloc] init];
        record.name = @"casa";
        [self.testTable insertRecord:record error:NULL];
    }

    NSLog(@"%@", self.testTable.queryCommand.database.databaseFilePath);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[CTPersistanceAsyncExecutor sharedInstance] read:^{
        NSInteger count = 98;
        while (count --> 0) {
            TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:@(count) error:NULL];
            NSLog(@"%@", record.primaryKey);
        }
    }];

    NSInteger count = 98;
    while (count --> 0) {
        [[CTPersistanceAsyncExecutor sharedInstance] read:^{
            TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:@(count) error:NULL];
            NSLog(@"%@", record.primaryKey);
        }];
    }

    [[CTPersistanceAsyncExecutor sharedInstance] write:^{
        NSInteger count = 100;
        while (count --> 0) {
            NSNumber *primaryKey = [self.testTable insertValue:@"casa" forKey:@"name" error:NULL];
            NSLog(@"%@", primaryKey);
        }
    }];

    count = 98;
    while (count --> 0) {
        [[CTPersistanceAsyncExecutor sharedInstance] read:^{
            TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:@(count) error:NULL];
            NSLog(@"%@", record.primaryKey);
        }];
    }

    count = 98;
    while (count --> 0) {
        [[CTPersistanceAsyncExecutor sharedInstance] read:^{
            NSNumber *primaryKey = [self.testTable insertValue:@"casa" forKey:@"name" error:NULL];
            NSLog(@"%@", primaryKey);
        }];
    }

    count = 98;
    while (count --> 0) {
        [[CTPersistanceAsyncExecutor sharedInstance] read:^{
            TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:@(count) error:NULL];
            NSLog(@"%@", record.primaryKey);
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"finished");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.testTable truncate];
}

#pragma mark - getters and setters
- (TestTable *)testTable
{
    if (_testTable == nil) {
        _testTable = [[TestTable alloc] init];
    }
    return _testTable;
}

@end
