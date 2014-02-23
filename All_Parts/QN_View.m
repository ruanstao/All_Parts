//
//  QN_View.m
//  All_Parts
//
//  Created by RuanSTao on 14-2-22.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//http://bea.wufazhuce.com:7001/OneForWeb/one/getQ_N?strUi=&strDate=2014-02-18&strRow=1

#import "QN_View.h"
#import "NSString+SBJSON.h"
#import "DataBaseSimple.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#define QNURL @"http://bea.wufazhuce.com:7001/OneForWeb/one/getQ_N?strUi=&strDate=%@&strRow=%d"
@interface QN_View()<ASIHTTPRequestDelegate,MBProgressHUDDelegate>

@end

@implementation QN_View
{
    DataBaseSimple * _simple;
    ASIHTTPRequest * _request;
    MBProgressHUD * _hud;
    __weak IBOutlet UILabel *_dayDate;
    __weak IBOutlet UIImageView *_offLine;
    __weak IBOutlet UIImageView *_answerImage;
    __weak IBOutlet UILabel *_questionContent;
    __weak IBOutlet UILabel *_answerTitle;
    __weak IBOutlet UILabel *_answerContent;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        _hud = [[MBProgressHUD alloc] initWithView:self];
        _hud.delegate =self;
        _hud.labelText = @"努力的加载中...";
        _hud.center =CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:_hud];
        [self startAnimation];
    }
    return self;
}
-(void) setData
{
    _simple=[DataBaseSimple sharedDataBase];
    NSDictionary * dic=[_simple getFromDataBaseFromTableName:@"all_question" withMarketTime:[_simple getDateForYestoday:(double)(_row-1)]];
    if (dic == nil) {
        NSString *strUrl=[NSString stringWithFormat:QNURL,[_simple getDate],_row];
        _request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]];
        _request.delegate=self;
        _request.tag=1111;
        [_request startAsynchronous];
    }else{
        _qnId=[dic objectForKey:@"id"];
        _questionTitle.text=[dic objectForKey:@"questiontitle"];
        _questionContent.text=[dic objectForKey:@"questioncontent"];
        _answerTitle.text=[dic objectForKey:@"answertitle"];
        _answerContent.text=[self resolveString:[dic objectForKey:@"answercontent"]];
        [self setTime:[dic objectForKey:@"markettime"]];
        [self reSetFrame];
    }
}
-(void) setTimeData
{
    _simple=[DataBaseSimple sharedDataBase];
    NSDictionary * dic=[_simple getFromDataBaseFromTableName:@"all_question" withMarketTime:_thingsTime];
    if (dic == nil) {
        NSString *strUrl=[NSString stringWithFormat:QNURL,[_simple getDate],_row];
        _request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]];
        _request.delegate=self;
        _request.tag=2222;
        [_request startAsynchronous];
    }else{
        _qnId=[dic objectForKey:@"id"];
        _questionTitle.text=[dic objectForKey:@"questiontitle"];
        _questionContent.text=[dic objectForKey:@"questioncontent"];
        _answerTitle.text=[dic objectForKey:@"answertitle"];
        _answerContent.text=[self resolveString:[dic objectForKey:@"answercontent"]];
        [self setTime:[dic objectForKey:@"markettime"]];
        [self reSetFrame];
    }

}
-(void) setTime:(NSString *)str
{
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * old=[formatter dateFromString:str];
    NSDateFormatter * d=[[NSDateFormatter alloc] init];
    [d setDateFormat:@"MMMM dd,yyyy"];
    _dayDate.text=[d stringFromDate:old];
}
-(NSString *) resolveString:(NSString *) str
{
    
    NSMutableString * change=[NSMutableString stringWithString:str];
    NSRange range=[change rangeOfString:@"<br>"];
    while (range.length!=0) {
        [change replaceCharactersInRange:range withString:@"\n"];
        range=[change rangeOfString:@"<br>"];
    }
    if ([change rangeOfString:@"<i>"].length!=0) {
        [change deleteCharactersInRange:[change rangeOfString:@"<i>"]];
        [change deleteCharactersInRange:[change rangeOfString:@"</i>"]];
    }
   return change;
    
}
-(void) reSetFrame
{
//questionTitle
    CGSize s=[_questionTitle.text sizeWithFont:_questionTitle.font constrainedToSize:CGSizeMake(_questionTitle.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    CGRect r=_questionTitle.frame;
    r.size=s;
    _questionTitle.frame=r;
//questionContent
    if ((_questionTitle.frame.origin.y+_questionTitle.frame.size.height+10)>_questionContent.frame.origin.y) {
        _questionContent.frame=CGRectMake(_questionContent.frame.origin.x,
                                          _questionTitle.frame.origin.y+_questionTitle.frame.size.height+10,
                                          _questionContent.frame.size.width,
                                          _questionContent.frame.size.height);
    }
    s=[_questionContent.text sizeWithFont:_questionContent.font constrainedToSize:CGSizeMake(_questionContent.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    r=_questionContent.frame;
    r.size=s;
    _questionContent.frame=r;
//offLine
    _offLine.frame=CGRectMake(_offLine.frame.origin.x,
                              r.origin.y+r.size.height+20,
                              _offLine.frame.size.width,
                              _offLine.frame.size.height);
//answerImage
    _answerImage.frame=CGRectMake(_answerImage.frame.origin.x,
                                  _offLine.frame.origin.y+20,
                                  _answerImage.frame.size.width,
                                  _answerImage.frame.size.height);
//answerTitle
    s=[_answerTitle.text sizeWithFont:_answerTitle.font constrainedToSize:CGSizeMake(_answerTitle.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    _answerTitle.frame=CGRectMake(_answerTitle.frame.origin.x,
                                  _offLine.frame.origin.y+20,
                                  _answerTitle.frame.size.width,
                                  s.height);
//answerContent
    CGFloat height=_answerImage.frame.origin.y+_answerImage.frame.size.height+20;
    if (height<_answerTitle.frame.origin.y+_answerTitle.frame.size.height+10) {
        height=_answerTitle.frame.origin.y+_answerTitle.frame.size.height+10;
    }
    s=[_answerContent.text sizeWithFont:_answerContent.font constrainedToSize:CGSizeMake(_answerContent.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    _answerContent.frame=CGRectMake(_answerContent.frame.origin.x,
                                    height,
                                    _answerContent.frame.size.width,
                                    s.height);
//scrollView
    _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width,
                                       _answerContent.frame.origin.y+_answerContent.frame.size.height+100);
    [self stopAnimation];
}
#pragma  mark - ASIHTTPRequestDelegate
-(void) requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary * dic=[[request responseString] JSONValue];
    //    NSLog(@"%@",dic);
    if ([[dic objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
        _simple=[DataBaseSimple sharedDataBase];
        [_simple insertDataForTableName:@"all_question" with:[dic objectForKey:@"questionAdEntity"]];
    }else{
        NSLog(@"%@ ASI error",[self class]);
    }
    if (request.tag==1111) {
        [self setData];
    }else{
        [self setTimeData];
    }
}
-(void) requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@ ASI error---%@",[self class],request.error);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
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
