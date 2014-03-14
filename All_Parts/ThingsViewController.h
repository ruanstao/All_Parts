//
//  ThingsViewController.h
//  All_Parts
//
//  Created by RuanSTao on 14-2-19.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveViewController.h"
@interface ThingsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSMutableArray * lstThing;
@property(nonatomic,strong) SaveViewController * save;
@end