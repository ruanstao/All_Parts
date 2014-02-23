//
//  C_N_ViewController.m
//  All_Parts
//
//  Created by RuanSTao on 14-2-18.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import "C_N_ViewController.h"
#import "UIViewController+NJKFullScreenSupport.h"
#import "CN_View.h"
#import "DataBaseSimple.h"
@interface C_N_ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *refreshScrollView;
@property (nonatomic) NJKScrollFullScreen *scrollProxy;

@end

@implementation C_N_ViewController
{
    EGORefreshTableHeaderView* _pullRightRefreshView;
    BOOL _reloading;
    ASIHTTPRequest * _request;
    DataBaseSimple * _simple;
}
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
    int pagewide = self.refreshScrollView.bounds.size.width;
    int height = self.refreshScrollView.bounds.size.height;
    [_refreshScrollView setScrollEnabled:YES];
    _refreshScrollView.contentSize = CGSizeMake(pagewide*10,height);
    for (int i=0;i<10; i++) {
        CN_View * v  =[[[NSBundle mainBundle] loadNibNamed:@"CN_View" owner:Nil options:nil] lastObject];
        v.frame=CGRectMake(320*i, 0, _refreshScrollView.bounds.size.width, _refreshScrollView.bounds.size.height);
        v.tag=100+i;
        v.row=i+1;
        v.scrollView.delegate = (id)_scrollProxy;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [v setData];
        });
        [_refreshScrollView addSubview:v];
        
    }
    
    [_refreshScrollView setShowsVerticalScrollIndicator:NO];
    [_refreshScrollView setShowsHorizontalScrollIndicator:NO];
    [_refreshScrollView setPagingEnabled:NO];
    _refreshScrollView.alwaysBounceHorizontal=YES;
    _refreshScrollView.delegate = self;
    //    [self.view addSubview:_scrollView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    // Do any additional setup after loading the view from its nib.
  
    // UIScrollViewDelegate and UITableViewDelegate methods proxy to ViewController
//    self.refreshScrollView.delegate = (id)_scrollProxy; // cast for surpress incompatible warnings
    
    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self];
     [self creatScrollView];
    _scrollProxy.delegate = self;
//    if (!IS_RUNNING_IOS7) {
//        // support full screen on iOS 6
//        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
////        self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
//    }
    if (_pullRightRefreshView == nil) {
		EGORefreshTableHeaderView * view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f-self.refreshScrollView.bounds.size.width, 0.0f, self.refreshScrollView.frame.size.width, self.refreshScrollView.bounds.size.height)];
        view.delegate = self;
        [self.refreshScrollView addSubview:view];
        _pullRightRefreshView=view;
		
	}
    _reloading = NO;
    self.navigationItem.titleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareBtn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton)];
//    Reachability * reach=[Reachability reachabilityForLocalWiFi];
//    if ([reach isReachable]) {
//        [self postOne];
//    }else{
//        _simple=[DataBaseSimple sharedDataBase];
//        [self resolve:[[[_simple getOnePost] JSONValue] objectForKey:@"entRet"]];
//    }
    
}
-(void) rightBarButton
{
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_scrollProxy reset];
    [self showNavigationBar:animated];
//    [self showToolbar:animated];
    [self showTabBar:animated];
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
    [self reloadAllView];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
	
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
    if (_refreshScrollView.contentOffset.x>0) {
        [_refreshScrollView setPagingEnabled:YES];
    }else{
        [_refreshScrollView setPagingEnabled:NO];
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
	[_pullRightRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.refreshScrollView];
	
}

#pragma mark -
#pragma mark NJKScrollFullScreenDelegate

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    [self moveNavigtionBar:deltaY animated:YES];
//    [self moveToolbar:-deltaY animated:YES]; // move to revese direction
    [self moveTabBar:-deltaY animated:YES];
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    [self moveNavigtionBar:deltaY animated:YES];
//    [self moveToolbar:-deltaY animated:YES];
    [self moveTabBar:-deltaY animated:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)proxy
{
    [self hideNavigationBar:YES];
//    [self hideToolbar:YES];
    [self hideTabBar:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)proxy
{
    [self showNavigationBar:YES];
//    [self showToolbar:YES];
    [self showTabBar:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_scrollProxy reset];
    [self showNavigationBar:YES];
//    [self showToolbar:YES];
    [self showTabBar:YES];
}
#pragma mark - My Method
-(void) reloadAllView
{
    //    NSLog(@"%d---%@",_scrollView.subviews.count,_scrollView.subviews[10] );
    for (int i = 0; i<10; i++) {
        CN_View * v= (CN_View *)[self.view viewWithTag:100+i];
        [v setData];
    }
}
@end
