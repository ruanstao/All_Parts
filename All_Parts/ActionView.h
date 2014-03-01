//
//  ActionView.h
//  suiyi
//
//  Created by brandy on 14-1-17.
//  Copyright (c) 2014年 XITEK. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIControlStateAll UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted
#define IOS7_OR_LATER		( [[UIDevice currentDevice].systemVersion doubleValue]>=7.0)

#define USEToolBarStyle

@interface ActionView : UIToolbar

- (void)showInView:(UIView *)theView;
-(void)dismiss;

@property(nonatomic,strong)UIButton* CancelButton;
@property(nonatomic,strong)UIButton* FollowButton;
@property(nonatomic,strong)UIView *transparentView;
//@property(nonatomic,strong)UIView *halfTRansparentView;
@property BOOL visible;
@property BOOL isFollow;
@property (nonatomic,strong)NSString * FollowButtonNormal;
@property (nonatomic,strong)NSString * FollowButtonSelect;
- (void)updateFollowStatus:(BOOL)follow;


@end
