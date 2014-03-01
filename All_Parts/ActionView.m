//
//  ActionView.m
//  suiyi
//
//  Created by brandy on 14-1-17.
//  Copyright (c) 2014年 XITEK. All rights reserved.
//

#import "ActionView.h"

@implementation ActionView
@synthesize CancelButton ,FollowButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.userInteractionEnabled = NO;
#ifdef USEToolBarStyle
        if (IOS7_OR_LATER) {
            // Use iOS 7 blurry goodness
            self.barStyle = UIBarStyleBlackTranslucent;
            self.tintColor = nil;
            self.barTintColor = nil;
            self.barStyle = UIBarStyleBlackTranslucent;
            [self setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        } else {
            // Transparent black with no gloss
            CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0 alpha:0.6] CGColor]);
            CGContextFillRect(context, rect);
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [self setBackgroundImage:image forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        }
        
#endif
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
//        _halfTRansparentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        _halfTRansparentView.backgroundColor=[UIColor whiteColor];
//        //        self.halfTRansparentView.alpha=0.3f;
//        [self addSubview:_halfTRansparentView];

        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 3, 200, 20)];
        [titleLable setTextAlignment:NSTextAlignmentCenter];
        [titleLable setText:@"更多更多"];
        [titleLable setTextColor:[UIColor grayColor]];
        [titleLable setFont:[UIFont systemFontOfSize:18]];
        [titleLable setBackgroundColor:[UIColor clearColor]];
        [self addSubview:titleLable];
        
        FollowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        FollowButton.frame = CGRectMake(10, self.frame.size.height-60*2, self.frame.size.width-20, 44);
        FollowButton.layer.borderWidth = 0.5;
        FollowButton.layer.borderColor = [[UIColor grayColor] CGColor];
        [FollowButton setTitle:NSLocalizedString(self.FollowButtonNormal, nil) forState:UIControlStateNormal];
        [FollowButton setTitle:NSLocalizedString(self.FollowButtonNormal, nil) forState:UIControlStateHighlighted];
        [FollowButton addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:FollowButton];
        
        CancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CancelButton.frame = CGRectMake(10, self.frame.size.height-60, self.frame.size.width-20, 44);
        CancelButton.layer.borderWidth = 0.5;
        CancelButton.layer.borderColor = [[UIColor grayColor] CGColor];
        [CancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [CancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateHighlighted];
        [CancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:CancelButton];
        
        self.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
        self.transparentView.backgroundColor = [UIColor blackColor];
        self.transparentView.alpha = 0.0f;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.numberOfTapsRequired = 1;
        [self.transparentView addGestureRecognizer:tap];
    }
    return self;
}
- (void)updateFollowStatus:(BOOL)follow
{
    self.isFollow = follow;
    if (self.FollowButton) {
        [FollowButton setTitle:follow ?NSLocalizedString(self.FollowButtonSelect, nil):NSLocalizedString(self.FollowButtonNormal, nil) forState:UIControlStateNormal];
        [FollowButton setTitle:follow ?NSLocalizedString(self.FollowButtonSelect, nil):NSLocalizedString(self.FollowButtonNormal, nil) forState:UIControlStateHighlighted];
    }
}
- (void)followAction
{
    NSLog(@"touch follow");
    [self updateFollowStatus:!self.isFollow];
//    [self removeFromView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SAVE" object:nil];
}

- (void)removeFromView {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^() {
                             self.transparentView.alpha = 0.0f;
                             self.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight([UIScreen mainScreen].bounds) + CGRectGetHeight(self.frame) / 2.0);
                         } completion:^(BOOL finished) {
                             [self.transparentView removeFromSuperview];
                             [self removeFromSuperview];
                             self.visible = NO;
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVE" object:nil];
                         }];
    
}

- (void)showInView:(UIView *)theView {
    
    [theView addSubview:self];
    [theView insertSubview:self.transparentView belowSubview:self];
    
    CGRect theScreenRect = [UIScreen mainScreen].bounds;
    
    float height;
    float x;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        height = CGRectGetHeight(theScreenRect);
        x = CGRectGetWidth(theView.frame) / 2.0;
        self.transparentView.frame = CGRectMake(self.transparentView.center.x, self.transparentView.center.y, CGRectGetWidth(theScreenRect), CGRectGetHeight(theScreenRect));
    } else {
        height = CGRectGetWidth(theScreenRect);
        x = CGRectGetHeight(theView.frame) / 2.0;
        self.transparentView.frame = CGRectMake(self.transparentView.center.x, self.transparentView.center.y, CGRectGetHeight(theScreenRect), CGRectGetWidth(theScreenRect));
    }
    
    self.center = CGPointMake(x, height + CGRectGetHeight(self.frame) / 2.0);
    self.transparentView.center = CGPointMake(x, height / 2.0);
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         self.transparentView.alpha = 0.25f;
                         if (IOS7_OR_LATER) {
                              self.center = CGPointMake(x, height  - CGRectGetHeight(self.frame) / 2.0);
                         } else {
                              self.center = CGPointMake(x, (height - 20) - CGRectGetHeight(self.frame) / 2.0);
                         }
                         
                     } completion:^(BOOL finished) {
                         self.visible = YES;
                     }];
}


-(void)dismiss
{
    
    [self removeFromView];
}


@end
