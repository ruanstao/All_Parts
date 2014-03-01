//
//  Hp_C_View.h
//  All_Parts
//
//  Created by RuanSTao on 14-2-18.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "UIImageView+WebCache.h"
#import "StrContentId.h"
#import "DataBaseSimple.h"
@interface Hp_C_View : UIView<ASIHTTPRequestDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *strOriginalImg;
@property (nonatomic,strong) StrContentId * strHpId;
@property (nonatomic,assign) NSInteger row;
@property (weak, nonatomic) IBOutlet UILabel *strContent;
@property (weak, nonatomic) IBOutlet UILabel *strAuthor;
@property (strong, nonatomic) NSString * sWebLK;
-(void) setData;
@end
//    "result": "SUCCESS",
//    "hpEntity": {
//        "sWebLk": "http://wufazhuce.com/one/vol.496",
//        "strAuthor": "梦见&绘图/猫夫人",
//        "strContent": "我一直在想，我到底是喜欢你， 还是需要一个影子，放在心里，让我喜欢。 by 佚名",
//        "strDayDiffer": "",
//        "strHpId": "510",
//        "strHpTitle": "VOL.496  ",
//        "strLastUpdateDate": "2014-02-18 22:33:25",
//        "strMarketTime": "2014-02-15",
//        "strOriginalImgUrl": "http://pic.yupoo.com/hanapp/DxZ62sQh/SpBTY.jpg",
//        "strPn": "9",
//        "strThumbnailUrl": "http://pic.yupoo.com/hanapp/DxZ62sQh/SpBTY.jpg"
