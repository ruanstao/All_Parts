//
//  ActionViewContent.h
//  Test
//
//  Created by liupeng on 1/17/14.
//  Copyright (c) 2014 crte. All rights reserved.
//
typedef enum
{
	ShareTypeSinaWeibo = 1,         /**< 新浪微博 */
	ShareTypeTencentWeibo = 2,      /**< 腾讯微博 */
    ShareTypeDouBan = 3,            /**< 豆瓣社区 */
    ShareTypeWeixiTimeline = 4,    /**< 微信朋友圈 */
    ShareTypeWeixiSession = 5,     /**< 微信好友 */
    ShareTypeWeixiFav = 6,         /**< 微信收藏 */
    ShareTypeSMS = 7,              /**< 短信分享 */
    ShareTypeCopy = 8,             /**< 拷贝 */
    ShareTypeAny = 9               /**< 任意平台 */
}
ShareType;

#import <UIKit/UIKit.h>

@class ActionViewContentCell;

@protocol ActionViewContentDelegate <NSObject>

- (int)numberOfItemsInActionSheet;
- (ActionViewContentCell*)cellForViewAtIndex:(NSInteger)index;
- (void)DidTapOnItemAtIndex:(NSInteger)index actionType:(NSInteger)type;

@end
@interface ActionViewContent : UIView
-(id)initwithIconSheetDelegate:(id<ActionViewContentDelegate>)delegate ItemCount:(int)cout;
@end


@interface ActionViewContentCell : UIView
@property (nonatomic,retain)UIImageView* iconView;
@property (nonatomic,retain)UILabel*     titleLabel;
@property (nonatomic,assign)int          index;
@property (nonatomic,assign)int          actionType;
@end