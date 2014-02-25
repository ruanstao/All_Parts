//
//  ThingsModel.h
//  All_Parts
//
//  Created by RuanSTao on 14-2-24.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//etObject:[rs stringForColumn:@"id"] forKey:@"id"];
//[dic setObject:[rs stringForColumn:@"tablename"] forKey:@"tablename"];
//[dic setObject:[rs stringForColumn:@"markettime"] forKey:@"markettime"];
//[dic setObject:[rs stringForColumn:@"title"] forKey:@"title"];

#import <Foundation/Foundation.h>

@interface ThingsModel : NSObject
@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * tablename;
@property (nonatomic,strong) NSString * markettime;
@property (nonatomic,strong) NSString * title;

@end
