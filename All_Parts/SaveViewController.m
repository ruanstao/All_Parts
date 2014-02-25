//
//  SaveViewController.m
//  All_Parts
//
//  Created by RuanSTao on 14-2-23.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import "SaveViewController.h"
#import "DataBaseSimple.h"
#import "QN_View.h"
#import "CN_View.h"
#import "MBProgressHUD.h"
@interface SaveViewController ()<UIActionSheetDelegate>
{
    DataBaseSimple * _simple;
    QN_View * _qn;
    CN_View * _cn;
}
@end

@implementation SaveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.titleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareBtn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton)];
    
    if ([_mod.tablename isEqualToString:@"all_question"]){
        _qn= (QN_View *) [[[NSBundle mainBundle] loadNibNamed:@"QN_View" owner:Nil options:Nil] lastObject];
        _qn.thingsTime= _mod.markettime;
        [_qn setTimeData];
        [self.view addSubview:_qn];
    }
    else if ([_mod.tablename isEqualToString:@"all_content"]){
       _cn=(CN_View *) [[[NSBundle mainBundle] loadNibNamed:@"CN_View" owner:Nil options:Nil] lastObject] ;
        _cn.thingsTime=_mod.markettime;
        [_cn setTimeData];
        [self.view addSubview:_cn];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - My Method
-(void) rightBarButton
{
    UIActionSheet * sheet=[[UIActionSheet alloc] initWithTitle:@"ALL_PARTS"delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:@"分享" otherButtonTitles:@"添加到收藏", nil];
    [sheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        //分享
        case 0:{
            
        }
            break;
        //添加收藏
        case 1:{

        }
            break;
        case 2:{
            
        }
            break;
        default:
            break;
    }
}

@end
