//
//  ViewController.m
//  TestFMDB
//
//  Created by tian zeng on 2018/9/12.
//  Copyright © 2018年 GLB. All rights reserved.
//

#define dataBasePath [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:dataBaseName]
#define dataBaseName @"test.sqlite"

#import "ViewController.h"
#import "FMDB.h"

@interface ViewController ()
@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,assign) NSInteger nameId ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _db = [FMDatabase databaseWithPath:dataBasePath];
    [self createTable];
    _nameId = 0;
}




- (IBAction)Create {
    _nameId = _nameId +1;
    NSString *name = [NSString stringWithFormat:@"Tian%li",_nameId];
    [self addData:name withAge:(int)_nameId];
}

- (IBAction)Delete:(id)sender {
    [self deleteData:@"Tian2"];
}
- (IBAction)Update {
    [self updateData:@"Tian3"];
}

- (IBAction)Query {
    [self queryData];
}

/**
 创建表格
 **/
-(void) createTable{
    if(![self.db open]){
        return;
    }
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL)";
    BOOL res = [self.db executeStatements:sqlCreateTable];
    if(!res){
        NSLog(@"创建表失败!");
    }else{
        NSLog(@"建表成功!");
    }
    [self.db close];

}

/**
 插入数据
 **/
-(void) addData:(NSString *)name withAge:(int)age{
    if(![self.db open]){
        return;
    }
    NSString *sql = @"INSERT INTO t_student (name,age) VALUES (?,?);";
    BOOL res = [self.db executeUpdate:sql,name,@(age)];
    if(!res){
        NSLog(@"添加数据失败!");
    }else{
        NSLog(@"添加数据成功!");
    }
    
    [self.db close];
}

/**
 删除数据.
 **/
-(void)deleteData:(NSString *) name{
    if(![self.db open]){
        return;
    }
    NSString *sql=@"DELETE FROM t_student WHERE name = ?";
    BOOL res = [self.db executeUpdate:sql,name];
    if(!res){
        NSLog(@"删除数据失败!");
    }else{
        NSLog(@"删除数据成功!");
    }
    
    [self.db close];
}

/**
 更新数据.
 **/
-(void) updateData:(NSString *)name{
    if(![self.db open]){
        return;
    }
    NSString *sql = @"UPDATE t_student SET age= ? WHERE name = ?";
    BOOL res = [self.db executeUpdate:sql,@(28),name];
    if(!res){
        NSLog(@"更新数据失败!");
    }else{
        NSLog(@"更新数据成功!");
    }
    
    [self.db close];
}
/**
 查询数据
 **/
-(void)queryData{
    if(![self.db open]){
        return;
    }
    NSString *sql = @"SELECT * FROM t_student";
    FMResultSet *resultSet = [self.db executeQuery:sql];
    while ([resultSet next]) {
        int idNUM = [resultSet intForColumn:@"id"];
        NSString *name=[resultSet objectForColumn:@"name"];
        int age = [resultSet intForColumn:@"age"];
        NSLog(@"id=%i,name=%@,age=%i",idNUM,name,age);
    }
    [resultSet close];
    [self.db close];
}


@end
