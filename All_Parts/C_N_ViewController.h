//
//  C_N_ViewController.h
//  All_Parts
//
//  Created by RuanSTao on 14-2-18.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKScrollFullScreen.h"
#import "EGORefreshTableHeaderView.h"
#import "ASIHTTPRequest.h"
@interface C_N_ViewController : UIViewController<NJKScrollFullscreenDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate>

@property (nonatomic,strong) NSMutableArray * lisCon;
@end

