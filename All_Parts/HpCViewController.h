//
//  Hp_C_ViewController.h
//  All_Parts
//
//  Created by RuanSTao on 14-2-18.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASMediaFocusManager.h"
#import "WeiboSDK.h"
@interface HpCViewController : UIViewController<EGORefreshTableHeaderDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate,WBHttpRequestDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray * lstHp;
@property (nonatomic,strong) ASMediaFocusManager * focusManager;
@end
