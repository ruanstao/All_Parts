//
//  Hp_C_View.m
//  All_Parts
//
//  Created by RuanSTao on 14-2-18.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import "Hp_C_View.h"
#import "MBProgressHUD.h"
#import "HpModel.h"
#define HPURL @"http://bea.wufazhuce.com:7001/OneForWeb/one/getHp_N?strDate=%@&strRow=%d"
//2014-02-18  4
@interface Hp_C_View()<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UILabel *strHpTitle;
@property (weak, nonatomic) IBOutlet UIImageView *strContentBackView;
@property (weak, nonatomic) IBOutlet UILabel *dayDate;
@property (weak, nonatomic) IBOutlet UILabel *daySubDate;
@end
@implementation Hp_C_View
{
    DataBaseSimple * _simple;
    ASIHTTPRequest * _request;
    MBProgressHUD * _hud;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor=[UIColor orangeColor];
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        _hud = [[MBProgressHUD alloc] initWithView:self];
        _hud.delegate =self;
        _hud.minShowTime=2;
        _hud.labelText = @"努力的加载中...";
        _hud.center =CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:_hud];
    }
    return self;
}
-(void) setData;
{   [self startAnimation];
    _simple=[DataBaseSimple sharedDataBase];
    HpModel * mod=[_simple getFromDataBaseFromTableName:@"all_homepage" withMarketTime:[_simple getDateForYestoday:(double)(_row-1)]];
    if (mod.ID == nil) {
        NSString *strUrl=[NSString stringWithFormat:HPURL,[_simple getDate],_row];
//        NSLog(@"%@",strUrl);
        _request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]];
        _request.delegate=self;
        [_request startAsynchronous];
    }else{
//        NSLog(@"%@",dic);
        _sWebLK=mod.sWebLk;
        _strHpTitle.text=mod.title;
        _strAuthor.text=[NSString stringWithFormat:@"%@\n%@",mod.author_introduce,mod.author];
        [self setContentText:mod.content];
        [self setTime:mod.markettime];
        [self setImage:mod.img_url];
    }
    
}
-(void) setTime:(NSString *)str
{
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _selfTime=str;
    NSDate * old=[formatter dateFromString:str];
//    NSLog(@"%@",old);
    NSDateFormatter * d=[[NSDateFormatter alloc] init];
    [d setDateFormat:@"dd"];
    _dayDate.text=[d stringFromDate:old];
    NSDateFormatter * sd=[[NSDateFormatter alloc] init];
    [sd setDateFormat:@"MMM,yyyy"];
    _daySubDate.text=[sd stringFromDate:old];
    
}
-(void) setImage:(NSString *) str
{
    SDWebImageManager * manger=[SDWebImageManager sharedManager];
    UIImage * img=[manger imageWithURL:[NSURL URLWithString:str]];
    if (img) {
        _strOriginalImg.image=img;
    }else{
    [_strOriginalImg setImageWithURL:[NSURL URLWithString:str]];
    }
    [self stopAnimation];
}
-(void) setContentText:(NSString *) str
{
    CGSize s=[str sizeWithFont:_strContent.font constrainedToSize:CGSizeMake(_strContent.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    _strContent.frame=CGRectMake(_strContent.frame.origin.x, _strContent.frame.origin.y, _strContent.frame.size.width, s.height);
    _strContent.text=str;
//    UIImage *img=_strContentBackView.image;
    _strContentBackView.image=[_strContentBackView.image resizableImageWithCapInsets:UIEdgeInsetsMake(25, 100, 5, 100) resizingMode:UIImageResizingModeStretch];
    _strContentBackView.frame=CGRectMake(_strContentBackView.frame.origin.x, _strContentBackView.frame.origin.y, _strContentBackView.frame.size.width, s.height+10);
    _scrollView.contentSize=CGSizeMake(320, _strContentBackView.frame.origin.y+_strContentBackView.frame.size.height+60);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma  mark - ASIHTTPRequestDelegate
-(void) requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary * dic=[[request responseString] JSONValue];
    //    NSLog(@"%@",dic);
    if ([[dic objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
        _simple=[DataBaseSimple sharedDataBase];
        [_simple insertDataForTableName:@"all_homepage" with:[dic objectForKey:@"hpEntity"]];
    }else{
        NSLog(@"%@ ASI error",[self class]);
    }
    [self setData];
//    [self reloadInputViews];
}
-(void) requestFailed:(ASIHTTPRequest *)request
{
      NSLog(@"%@ ASI error---%@",[self class],request.error);
}

#pragma mark - My Method
-(void) resolve:(NSDictionary * ) dic
{

}
//{
//    "sWebLk": "http://wufazhuce.com/one/vol.501",
//    "strAuthor": "冰雕匠&摄影/安一然",
//    "strContent": "有些事情我不看透，不是我太笨，只是我太善良。from《樱桃小丸子》",
//    "strDayDiffer": "",
//    "strHpId": "520",
//    "strHpTitle": "VOL.501",
//    "strLastUpdateDate": "2014-02-19 21:43:55",
//    "strMarketTime": "2014-02-20",
//    "strOriginalImgUrl": "http://pic.yupoo.com/hanapp/Dy83BPCX/tcK8O.jpg",
//    "strPn": "6",
//    "strThumbnailUrl": "http://pic.yupoo.com/hanapp/Dy83BPCX/tcK8O.jpg"
//}
#pragma mark -- MBProgressHUDDelegate

#pragma mark - MBP Method
- (void) startAnimation
{
	[_hud show:YES];
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = YES;
}

- (void) stopAnimation
{
	[_hud hide:YES];
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = NO;
}
@end
