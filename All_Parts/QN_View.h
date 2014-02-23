//
//  QN_View.h
//  All_Parts
//
//  Created by RuanSTao on 14-2-22.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//{
//"result": "SUCCESS",
//"questionAdEntity": {
//    "entQNCmt": {
//        "pNum": "",
//        "strCnt": "",
//        "strD": "",
//        "strId": "",
//        "upFg": ""
//    },
//    "sWebLk": "http://wufazhuce.com/one/vol.499#cuestion",
//    "strAnswerContent": "因为有的人的人生是良性循环，有的人的人生是恶性循环。<br人间最自由的执念。<br><br><br><i>（责任编辑：贺伊曼）</i>",
//    "strAnswerTitle": "知乎用户明溪（微博ID：@风骚的板栗）答匿名：",
//    "strDayDiffer": "",
//    "strLastUpdateDate": "2014-02-22 23:36:33",
//    "strPraiseNumber": "17855",
//    "strQuestionContent": "匿名问：同样25岁，为什么有的人事业小成，家庭幸福，有的人却还在一无所有的起点上？",
//    "strQuestionId": "510",
//    "strQuestionMarketTime": "2014-02-18",
//    "strQuestionTitle": "同样25岁，为何生活差别如此大？"
//}
//}

#import <UIKit/UIKit.h>

@interface QN_View : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,assign) NSInteger row;
-(void) setData;
@end
