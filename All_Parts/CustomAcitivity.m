//
//  CustomAcitivity.m
//  All_Parts
//
//  Created by RuanSTao on 14-2-24.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import "CustomAcitivity.h"

@implementation CustomAcitivity
{
    NSString * _title;
    UIImage * _img;
    NSURL * _url;
}
- (id)initWithTitle:(NSString *)str  andImage:(UIImage *) img andUrl:(NSURL *)url
{
    self = [super init];
    if (self) {
        _title=str;
        _img=img;
        _url=url;
    }
    return self;
}
- (NSString *)activityType {
    return @"customAppType";
}
- (NSString *)activityTitle {
    return _title;
}
- (UIImage *) activityImage {
    return _img;
}
- (BOOL) canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}
- (void) prepareWithActivityItems:(NSArray *)activityItems {
}
- (UIViewController *) activityViewController {
    return nil;
}
- (void) performActivity {
    [[UIApplication sharedApplication] openURL:_url];
}
@end
