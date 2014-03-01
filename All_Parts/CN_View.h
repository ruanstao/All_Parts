//
//  CN_View.h
//  All_Parts
//
//  Created by RuanSTao on 14-2-20.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
////{
//"result": "SUCCESS",
//"contentEntity": {
//    "sAuth": "易小星，作家、导演。",
//    "sGW": "他是一个高尚的人，一个脱离了低级趣味的人，一个天天与同学打交道，遇到同学有难处，不论分内分外，都往自己怀里揽的人……他为四（一）班谱写了一曲安定和谐的时代凯歌……",
//    "sWbN": "@叫兽易小星",
//    "sWebLk": "http://wufazhuce.com/one/vol.501#articulo",
//    "strContAuthor": "易小星 ",
//    "strContAuthorIntroduce": "（责任编辑：薛诗汉）",
//    "strContDayDiffer": "",
//    "strContMarketTime": "2014-02-20",
//    "strContTitle": "风波",
//    "strContent": "（编者按：此文原刊在2012年时候，厚信封是新的一天。<br><br><br><b>易小星，作家、导演。@叫兽易小星</b>",
//    "strContentId": "569",
//    "strLastUpdateDate": "2014-02-19 23:30:40",
//    "strPraiseNumber": "6440"
//
#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "StrContentId.h"
@interface CN_View : UIView<ASIHTTPRequestDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *contTitle;
@property( nonatomic,strong) StrContentId * strContentId;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,strong) NSString * conId;
@property (nonatomic,strong) NSString * selfTime;
@property (nonatomic,strong) NSString * thingsTime;
-(void) setData;
-(void) setTimeData;
@end
