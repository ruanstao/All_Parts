//
//  CNModel.h
//  All_Parts
//
//  Created by RuanSTao on 14-2-24.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//
//[dic setObject:[rs stringForColumn:@"id"] forKey:@"id"];
//[dic setObject:[rs stringForColumn:@"conttitle"] forKey:@"conttitle"];
//[dic setObject:[rs stringForColumn:@"contauthor"] forKey:@"contauthor"];
//[dic setObject:[rs stringForColumn:@"content"] forKey:@"content"];
//[dic setObject:[rs stringForColumn:@"contauthorintroduce"] forKey:@"contauthorintroduce"];
//[dic setObject:[rs stringForColumn:@"sauth"] forKey:@"sauth"];
//[dic setObject:[rs stringForColumn:@"sgw"] forKey:@"sgw"];
//[dic setObject:[rs stringForColumn:@"swbn"] forKey:@"swbn"];
//[dic setObject:[rs stringForColumn:@"sweblk"] forKey:@"sweblk"];
//[dic setObject:[rs stringForColumn:@"contmarkettime"] forKey:@"contmarkettime"];
//[dic setObject:[rs stringForColumn:@"lastupdatedate"] forKey:@"lastupdatedate"];
//[dic setObject:[rs stringForColumn:@"praisenumber"] forKey:@"praisenumber"];
#import <Foundation/Foundation.h>

@interface CNModel : NSObject
@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * conttitle;
@property (nonatomic,strong) NSString * contauthor;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * contauthorintroduce;
@property (nonatomic,strong) NSString * sauth;
@property (nonatomic,strong) NSString * sgw;
@property (nonatomic,strong) NSString * swbn;
@property (nonatomic,strong) NSString * sweblk;
@property (nonatomic,strong) NSString * contmarkettime;
@property (nonatomic,strong) NSString * lastupdatedate;
@property (nonatomic,strong) NSString * praisenumber;
@end
