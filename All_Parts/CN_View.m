//
//  CN_View.m
//  All_Parts
//
//  Created by RuanSTao on 14-2-20.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import "CN_View.h"
#import "DataBaseSimple.h"
#import "NSString+SBJSON.h"
#import "MBProgressHUD.h"
#import "CNModel.h"
#define CNURL @"http://bea.wufazhuce.com:7001/OneForWeb/one/getC_N?strDate=%@&strRow=%d"
@interface CN_View()<MBProgressHUDDelegate>

@end
@implementation CN_View
{
    DataBaseSimple * _simple;
    ASIHTTPRequest * _request;
    MBProgressHUD * _hud;
    __weak IBOutlet UILabel *_dayDate;
    __weak IBOutlet UILabel *_contAuthor;
    __weak IBOutlet UILabel *_content;
    __weak IBOutlet UILabel *_contAuthorIntroduce;
    __weak IBOutlet UILabel *_contAuthorDesc;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        _hud=[[MBProgressHUD alloc] initWithView:self];
        _hud.delegate=self;
        _hud.labelText=@"努力的加载中……";
        _hud.center =CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:_hud];
    }
    return self;
}
-(void) setData
{  [self startAnimation];
    _simple=[DataBaseSimple sharedDataBase];
    CNModel * mod =[_simple getFromDataBaseFromTableName:@"all_content" withMarketTime:[_simple getDateForYestoday:(double)(_row-1)]];
    if (mod.ID == nil) {
        NSString *strUrl=[NSString stringWithFormat:CNURL,[_simple getDate],_row];
//       NSLog(@"%@----%@",[_simple getDateForYestoday:(double)(_row-1)],strUrl);
        _request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]];
        _request.tag=33;
        _request.delegate=self;
        [_request startAsynchronous];
    }else{
//        NSLog(@"%@",dic);
        _conId=mod.ID;
        _contTitle.text=mod.conttitle;
        _contAuthor.text=mod.contauthor;
        _contAuthorIntroduce.text=mod.contauthorintroduce;
        [self setContentText:mod.content];
        [self setTime:mod.contmarkettime];
//        [self setImage:[dic objectForKey:@"img_url"]];
    }
}
-(void) setTimeData
{
    _simple=[DataBaseSimple sharedDataBase];
    CNModel * mod =[_simple getFromDataBaseFromTableName:@"all_content" withMarketTime:_thingsTime];
    if (mod.ID == nil) {
        NSString *strUrl=[NSString stringWithFormat:CNURL,[_simple getDate],_row];
        //       NSLog(@"%@----%@",[_simple getDateForYestoday:(double)(_row-1)],strUrl);
        _request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]];
        _request.tag=44;
        _request.delegate=self;
        [_request startAsynchronous];
    }else{
        //        NSLog(@"%@",dic);
        _conId=mod.ID;
        _contTitle.text=mod.conttitle;
        _contAuthor.text=mod.contauthor;
        _contAuthorIntroduce.text=mod.contauthorintroduce;
        [self setContentText:mod.content];
        [self setTime:mod.contmarkettime];
        //        [self setImage:[dic objectForKey:@"img_url"]];
    }
}
-(void) setTime:(NSString *)str
{
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * old=[formatter dateFromString:str];
    _selfTime=str;
    //    NSLog(@"%@",old);
    NSDateFormatter * d=[[NSDateFormatter alloc] init];
    [d setDateFormat:@"MMMM dd,yyyy"];
    _dayDate.text=[d stringFromDate:old];
//    NSDateFormatter * sd=[[NSDateFormatter alloc] init];
//    [sd setDateFormat:@"MMM,yyyy"];
//    _daySubDate.text=[sd stringFromDate:old];
    
}
-(void) setContentText:(NSString *) str
{
    NSMutableString * change=[NSMutableString stringWithString:str];
    NSRange range=[change rangeOfString:@"<br>"];
    while (range.length!=0) {
      
        [change replaceCharactersInRange:range withString:@"\n"];
        range=[change rangeOfString:@"<br>"];
    }
    NSRange begin= [change rangeOfString:@"<b>"];
    NSRange end=[change rangeOfString:@"</b>"];
    NSRange all=NSMakeRange(begin.location, end.location + end.length - begin.location);
    NSRange sub=NSMakeRange(begin.location+ begin.length, end.location-begin.location-begin.length);
    _contAuthorDesc.text=[change substringWithRange:sub];
    [change deleteCharactersInRange:all];
    CGSize s=[change sizeWithFont:_content.font constrainedToSize:CGSizeMake(_content.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
//    NSLog(@"%f,%f,%f,%f",_content.frame.origin.x,_content.frame.origin.y,_content.frame.size.width,_content.frame.size.height);
    if (s.height>8000) {

                [self setLargeContentStr:change];

    } else{
    _content.frame=CGRectMake(_content.frame.origin.x, _content.frame.origin.y, _content.frame.size.width, s.height);
    _content.text=change;
    _contAuthorIntroduce.frame=CGRectMake(_contAuthorIntroduce.frame.origin.x,
                                          _content.frame.origin.y+_content.frame.size.height+8,
                                          _contAuthorIntroduce.frame.size.width,
                                          _contAuthorIntroduce.frame.size.height);
    _contAuthorDesc.frame=CGRectMake(_contAuthorDesc.frame.origin.x,
                                     _contAuthorIntroduce.frame.origin.y+_contAuthorIntroduce.frame.size.height+8,
                                     _contAuthorDesc.frame.size.width,
                                     _contAuthorDesc.frame.size.height);

    _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, s.height+_contAuthorIntroduce.frame.size.height+_contAuthorDesc.frame.size.height +300);
    }
    [self stopAnimation];
}
//
//    UIImage *img=_strContentBackView.image;
//    _strContentBackView.image=[_strContentBackView.image resizableImageWithCapInsets:UIEdgeInsetsMake(25, 100, 5, 100) resizingMode:UIImageResizingModeStretch];
//    _strContentBackView.frame=CGRectMake(_strContentBackView.frame.origin.x, _strContentBackView.frame.origin.y, _strContentBackView.frame.size.width, s.height+10);

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
        [_simple insertDataForTableName:@"all_content" with:[dic objectForKey:@"contentEntity"]];
       
    }else{
        NSLog(@"%@ ASI error",[self class]);
    }
    if (request.tag==33) {
        [self setData];
    }else if(request.tag==44){
        [self setTimeData];
    }
    
    [self reloadInputViews];
}
-(void) requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@ ASI error---%@",[self class],request.error);
}

#pragma mark - My Method
-(void) resolve:(NSDictionary * ) dic
{
    
}
-(void) setLargeContentStr:(NSString*) text
{
    //确定frame.size
    //一行需要的size
//    _content.text=text;
//    NSLog(@"%@",_content.text);
    CGSize oneTextSize = [@"一行的高度" sizeWithFont:_content.font
                            constrainedToSize:CGSizeMake(_content.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    //500最多多少行
    int maxRow=500.0/oneTextSize.height;
//    dispatch_async(dispatch_get_main_queue(), ^{
        _content.frame=CGRectMake(_content.frame.origin.x,
                                  _content.frame.origin.y,
                                  _content.frame.size.width,
                                  maxRow * oneTextSize.height);
//    });
    
//    NSLog(@"%f---%f----%f----%f",_content.frame.origin.x,
//          _content.frame.origin.y,
//          _content.frame.size.width,
//          maxRow*oneTextSize.height);
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    int totalPages = 0;
    int currentPage = 0;
    
        // 计算文本串的大小尺寸
    CGSize totalTextSize = [text sizeWithFont:_content.font
                                constrainedToSize:CGSizeMake(_content.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
//    NSLog(@"%f---%f",totalTextSize.width,totalTextSize.height);
    // 计算理想状态下的页面数量和每页所显示的字符数量，只是拿来作为参考值用而已！
    NSUInteger textLength = [text length];
    int referTotalPages = (int)totalTextSize.height/(int)_content.frame.size.height+1;
    int referCharatersPerPage = textLength/referTotalPages;
    
    // 申请最终保存页面NSRange信息的数组缓冲区
    int maxPages = referTotalPages;
    NSRange * rangeOfPages= (NSRange *)malloc(referTotalPages*sizeof(NSRange));
    
    memset(rangeOfPages, 0x0, referTotalPages*sizeof(NSRange));
    
    // 页面索引
    int page = 0;
            
    for (NSUInteger location = 0; location < textLength; ) {
        // 先计算临界点（尺寸刚刚超过UILabel尺寸时的文本串）
        NSRange range = NSMakeRange(location, referCharatersPerPage);
        // reach end of text ?
        NSString *pageText;
        CGSize pageTextSize;
                
        while (range.location + range.length < textLength) {
            pageText = [text substringWithRange:range];
                    
            CGSize pageTextSize = [pageText sizeWithFont:_content.font
                                        constrainedToSize:CGSizeMake(_content.frame.size.width, MAXFLOAT)
                                            lineBreakMode:NSLineBreakByCharWrapping];
                    
            if (pageTextSize.height > _content.frame.size.height) {
                break;
                } else {
                    range.length += referCharatersPerPage;
                }
            }
        
        if (range.location + range.length >= textLength) {
                range.length = textLength - range.location;
            }
                
            // 然后一个个缩短字符串的长度，当缩短后的字符串尺寸小于textLabel的尺寸时即为满足
        while (range.length > 0) {
                pageText = [text substringWithRange:range];
                    
                pageTextSize = [pageText sizeWithFont:_content.font
                                        constrainedToSize:CGSizeMake(_content.frame.size.width, MAXFLOAT)
                                            lineBreakMode:NSLineBreakByCharWrapping];
                    
                if (pageTextSize.height <= _content.frame.size.height) {
                    range.length = [pageText length];
                    break;
                } else {
                    range.length-=20;
                    CGSize sss=[[text substringWithRange:range] sizeWithFont:_content.font constrainedToSize:CGSizeMake(_content.frame.size.width, MAXFLOAT)
                lineBreakMode:NSLineBreakByCharWrapping];
                    if (sss.height<=_content.frame.size.height) {
                        range.length+=20;
                    }
                    range.length -= 2;
                }
            }
                
        // 得到一个页面的显示范围
        if (page >= maxPages) {
            maxPages += 10;
            rangeOfPages = (NSRange *)realloc(rangeOfPages, maxPages*sizeof(NSRange));
        }
        rangeOfPages[page++] = range;
        // 更新游标
        location += range.length;
    }

    // 获取最终页面数量
    totalPages = page;
            
    // 更新UILabel内容
//    NSLog(@"%@",[text substringWithRange:rangeOfPages[0]]);
    dispatch_async(dispatch_get_main_queue(), ^{
        _content.text = [text substringWithRange:rangeOfPages[0]];

    CGFloat height=_content.frame.origin.y+_content.frame.size.height;
    for (int i=1; i<totalPages; i++) {
        UILabel * lab=[[UILabel alloc] init];
        lab.text=[text substringWithRange:rangeOfPages[i]];
        CGSize s=[lab.text sizeWithFont:_content.font constrainedToSize:_content.frame.size lineBreakMode:NSLineBreakByCharWrapping];
                lab.font=_content.font;
        lab.numberOfLines=0;
        lab.frame=CGRectMake(_content.frame.origin.x,
                             height,
                             _content.frame.size.width,
                             s.height);
        [self.scrollView addSubview:lab];
        height+=s.height;
//        lab.backgroundColor=[UIColor colorWithRed:random()%256/256.0 green:random()%256/256.0 blue:random()%256/256.0 alpha:1];
        
        
                        _contAuthorIntroduce.frame=CGRectMake(_contAuthorIntroduce.frame.origin.x,
                                                  lab.frame.origin.y+lab.frame.size.height+8,
                                                  _contAuthorIntroduce.frame.size.width,
                                                  _contAuthorIntroduce.frame.size.height);
            _contAuthorDesc.frame=CGRectMake(_contAuthorDesc.frame.origin.x,
                                             _contAuthorIntroduce.frame.origin.y+_contAuthorIntroduce.frame.size.height+8,
                                             _contAuthorDesc.frame.size.width,
                                             _contAuthorDesc.frame.size.height);
            
            _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width,_contAuthorDesc.frame.origin.y + _contAuthorDesc.frame.size.height +100);
        }
    });
   
     });
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
