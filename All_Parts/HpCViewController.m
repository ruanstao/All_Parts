//
//  Hp_C_ViewController.m
//  All_Parts
//
//  Created by RuanSTao on 14-2-18.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import "HpCViewController.h"
#import "C_N_ViewController.h"
#import "ThingsViewController.h"
#import "NSString+SBJSON.h"
#import "Hp_C_View.h"
#import "StrContentId.h"
#import "Reachability.h"
#import "DataBaseSimple.h"
#define POSTONE @"Post  http://bea.wufazhuce.com:7001/OneForWeb/one/o_m"
@interface HpCViewController ()
{
    EGORefreshTableHeaderView* _pullRightRefreshView;
    BOOL _reloading;
    ASIHTTPRequest * _request;
    ASIFormDataRequest * _fromDataRequest;
    DataBaseSimple * _simple;
}
@end

@implementation HpCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)creatScrollView
{
    int pagewide = self.scrollView.bounds.size.width;
    int height = self.scrollView.bounds.size.height;
    [_scrollView setScrollEnabled:YES];
    _scrollView.contentSize = CGSizeMake(pagewide*10,height);
    for (int i=0;i<10; i++) {
        Hp_C_View * v=[[[NSBundle mainBundle]loadNibNamed:@"Hp_C_View" owner:Nil options:Nil] lastObject];
        v.frame=CGRectMake(320*i, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        v.tag=100+i;
        [_scrollView addSubview:v];
    }

    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setPagingEnabled:NO];
    _scrollView.alwaysBounceHorizontal=YES;
    _scrollView.delegate = self;
//    [self.view addSubview:_scrollView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor=[UIColor orangeColor];
    // Do any additional setup after loading the view from its nib.
    [self creatScrollView];
    if (_pullRightRefreshView == nil) {
		EGORefreshTableHeaderView * view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f-self.scrollView.bounds.size.width, 0.0f, self.scrollView.frame.size.width, self.scrollView.bounds.size.height)];
        view.delegate = self;
        [self.scrollView addSubview:view];
        _pullRightRefreshView=view;
		
	}
    _reloading = NO;
    self.navigationItem.titleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareBtn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton)];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Reachability * reach=[Reachability reachabilityForLocalWiFi];
        if ([reach isReachable]) {
            [self postOne];
        }else{
            _simple=[DataBaseSimple sharedDataBase];
            [self resolve:[[[_simple getOnePost] JSONValue] objectForKey:@"entRet"]];
        }
//    });
    
}
-(void) rightBarButton
{
    
}
- (void)viewDidUnload
{
    _pullRightRefreshView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)dealloc
{
    _pullRightRefreshView = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    [self postOne];
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
    
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
	return [NSDate date]; // should return date data source was last changed
	
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_pullRightRefreshView egoRefreshScrollViewDidScroll:scrollView];
//    NSLog(@"%f",scrollView.contentOffset.x);
    if (_scrollView.contentOffset.x>0) {
        [_scrollView setPagingEnabled:YES];
    }else{
        [_scrollView setPagingEnabled:NO];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_pullRightRefreshView egoRefreshScrollViewDidEndDragging:scrollView];
	
}
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
    
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_pullRightRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
	
}
#pragma mark - ASI Method

-(void) postOne
{
//    _reloading=YES;
    _fromDataRequest=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://bea.wufazhuce.com:7001/OneForWeb/one/o_m"]];
    _fromDataRequest.delegate=self;
    [_fromDataRequest startAsynchronous];
}
#pragma mark - ASIHTTPRequestDelegate
-(void) requestFinished:(ASIHTTPRequest *)request
{
//    _reloading=NO;
    [self doneLoadingTableViewData];
    NSDictionary * dic=[[request responseString] JSONValue];
//    NSLog(@"%@",dic);
    if ([[dic objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
        _simple=[DataBaseSimple sharedDataBase];
        [_simple insertOnePost:[request responseString]];
        [self resolve:[dic objectForKey:@"entRet"]];
    }else{
        NSLog(@"%@ ASI error",[self class]);
    }
                                
}
-(void) requestFailed:(ASIHTTPRequest *)request
{
//    _reloading=NO;
    _simple=[DataBaseSimple sharedDataBase];
    
    if ([[_simple getOnePost] JSONValue]) {
         [self resolve:[[[_simple getOnePost] JSONValue] objectForKey:@"entRet"]];
    }
    [self doneLoadingTableViewData];
      NSLog(@"%@ ASI error---%@",[self class],request.error);
}
#pragma mark - My Method
-(void) resolve:(NSDictionary * ) dic
{
    
    NSMutableArray * hp=[NSMutableArray array];
    for (NSDictionary * obj in [dic objectForKey:@"lstHp"]){
        StrContentId * s=[[StrContentId alloc] init];
        s.contentId=[obj objectForKey:@"strContentId"];
        s.praiseNumber=[obj objectForKey:@"strPraiseNumber"];
        [hp addObject:s];
    }
    
    NSMutableArray * con=[NSMutableArray array];
    for (NSDictionary * obj in [dic objectForKey:@"lstCon"]){
        StrContentId * s=[[StrContentId alloc] init];
        s.contentId=[obj objectForKey:@"strContentId"];
        s.praiseNumber=[obj objectForKey:@"strPraiseNumber"];
        [con addObject:s];
    }
    NSMutableArray * thi=[NSMutableArray array];
    for (NSDictionary * obj in [dic objectForKey:@"lstThing"]){
        StrContentId * s=[[StrContentId alloc] init];
        s.contentId=[obj objectForKey:@"strContentId"];
        s.praiseNumber=[obj objectForKey:@"strPraiseNumber"];
        [thi addObject:s];
    }
    
    self.lstHp=hp;
    NSArray * arr= self.tabBarController.viewControllers;
    C_N_ViewController * c =[[[arr objectAtIndex:1] viewControllers] lastObject];
    c.lisCon=con;
    ThingsViewController *t=[[[arr objectAtIndex:3] viewControllers] lastObject];
    t.lstThing=thi;
    [self reloadAllView];
    
}
//2014-02-19 19:55:21.476 All_Parts[735:70b] <HpCViewController: 0x8b7fa60>
//2014-02-19 19:55:26.276 All_Parts[735:70b] <C_N_ViewController: 0x8b7ff30>
//2014-02-19 19:55:27.447 All_Parts[735:70b] <Q_N_ViewController: 0x8b80330>
//2014-02-19 19:55:28.027 All_Parts[735:70b] <ThingsViewController: 0x8b80740>
//2014-02-19 19:55:28.563 All_Parts[735:70b] <PersonalViewController: 0x8b80b20>
-(void) reloadAllView
{
//    NSLog(@"%d---%@",_scrollView.subviews.count,_scrollView.subviews[10] );
    for (int i = 0; i<10; i++) {
        Hp_C_View * v= (Hp_C_View *)[self.view viewWithTag:100+i];
        v.row=i+1;
//        v.strHpId=_lstHp[i];
        [v setData];
    }
}

@end
