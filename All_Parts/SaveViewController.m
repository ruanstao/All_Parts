//
//  SaveViewController.m
//  All_Parts
//
//  Created by RuanSTao on 14-2-23.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import "SaveViewController.h"
#import "QN_View.h"
#import "CN_View.h"
@interface SaveViewController ()

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
//    if ([[_dic objectForKey:@"tablename"] isEqualToString:@"all_question"]){
//        QN_View * v= (QN_View *) [[[NSBundle mainBundle] loadNibNamed:@"QN_View" owner:Nil options:Nil] lastObject];
//        v.thingsTime= [_dic objectForKey:@"markettime"];
//        [v setTimeData];
//        [self.view addSubview:v];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
