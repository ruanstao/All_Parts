//
//  DataBaseSimple.h
//  XMLDemo01
//
//  Created by 毛志 on 14-1-16.
//  Copyright (c) 2014年 maozhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DataBaseSimple : NSObject

// 获取数据库对象 - (void)openDataBase 该接口重写init方法
+ (DataBaseSimple *)sharedDataBase;

- (NSDictionary*)getFromDataBaseFromTableName:(NSString*)name withMarketTime:(NSString *)time;
- (NSString *) getDate;
- (NSString *) getDateForYestoday:(double) day;
-(NSString *) getOnePost;
- (BOOL)insertDataForTableName:(NSString *)name with:(NSDictionary*)dic;
- (BOOL) insertOnePost:(NSString*) str;
-(NSArray *) getDataFromAllThings;
//- (BOOL)deleteDataWithKey:(NSInteger)index;
//- (BOOL)updataDataWithkey:(NSInteger)index andModifyData:(NewsModel *)model;
//- (NSMutableArray *)selectFromDataBase:(NSString *)name;
//- (BOOL)cleanTable:(NSString *)name;
//- (BOOL)deleteTable:(NSString *)name;
@end
