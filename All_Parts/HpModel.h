//
//  HpModel.h
//  All_Parts
//
//  Created by RuanSTao on 14-2-24.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//[dic setObject:[rs stringForColumn:@"id"] forKey:@"id"];
//[dic setObject:[rs stringForColumn:@"title"] forKey:@"title"];
//[dic setObject:[rs stringForColumn:@"img_url"] forKey:@"img_url"];
//[dic setObject:[rs stringForColumn:@"author"] forKey:@"author"];
//[dic setObject:[rs stringForColumn:@"author_introduce"] forKey:@"author_introduce"];
//[dic setObject:[rs stringForColumn:@"content"] forKey:@"content"];
//             [dic setObject:[rs stringForColumn:@"laud_count"] forKey:@"laud_count"];
//             [dic setObject:[rs stringForColumn:@"laud_flg"] forKey:@"laud_flg"];
//[dic setObject:[rs stringForColumn:@"markettime"] forKey:@"markettime"];
//             [dic setObject:[rs stringForColumn:@"differ"] forKey:@"differ"];
//             [dic setObject:[rs stringForColumn:@"last_time"] forKey:@"last_time"];
//             [dic setObject:[rs stringForColumn:@"shareUrl"] forKey:@"shareUrl"];
//             [dic setObject:[rs stringForColumn:@"WxDesContent"] forKey:@"WxDesContent"];
//[dic setObject:[rs stringForColumn:@"sWebLk"] forKey:@"sWebLk"];


#import <Foundation/Foundation.h>

@interface HpModel : NSObject
@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * img_url;
@property (nonatomic,strong) NSString * author;
@property (nonatomic,strong) NSString * author_introduce;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * laud_count;
@property (nonatomic,strong) NSString * laud_flg;
@property (nonatomic,strong) NSString * markettime;
@property (nonatomic,strong) NSString * differ;
@property (nonatomic,strong) NSString * last_time;
@property (nonatomic,strong) NSString * shareUrl;
@property (nonatomic,strong) NSString * WxDesContent;
@property (nonatomic,strong) NSString * sWebLk;

@end
