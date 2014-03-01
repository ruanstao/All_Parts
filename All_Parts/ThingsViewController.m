//
//  ThingsViewController.m
//  All_Parts
//
//  Created by RuanSTao on 14-2-19.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import "ThingsViewController.h"
#import "SaveViewController.h"
#import "DataBaseSimple.h"
#import "ThingsModel.h"
@interface ThingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray * things;
@end

@implementation ThingsViewController
{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    self.navigationItem.titleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareBtn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(rightBarButton)];

    // Do any additional setup after loading the view from its nib.
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
}
-(void) viewWillAppear:(BOOL)animated
{
    _simple=[DataBaseSimple sharedDataBase];
    _things=[_simple getDataFromAllThings];
    [_tableView reloadData];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma mark - UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    return 1;
}
-(NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    return _things.count;
//    return 1;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    ThingsModel * mod=_things[indexPath.row];
    cell.textLabel.text=mod.title;
//    cell.textLabel.text=@"adsf";
    cell.detailTextLabel.text=mod.markettime;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines=0;
    cell.detailTextLabel.font=[UIFont systemFontOfSize:13];
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThingsModel * model=_things[indexPath.row];
//    NSString * str=[_things[indexPath.row] objectForKey:@"title"];
    CGSize s=[model.title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    return s.height+20;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%d",indexPath.row);
   _save=[[SaveViewController alloc] init];
    _save.mod=_things[indexPath.row];
    [self.navigationController pushViewController: _save animated:YES];
}
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        ThingsModel * things=_things[indexPath.row];
        _simple=[DataBaseSimple sharedDataBase];
        [_simple deleteDataWithID:things.ID];
    }
    _things=[_simple getDataFromAllThings];
    [_tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - My Method
-(void) rightBarButton
{
//    UIActionSheet * sheet=[[UIActionSheet alloc] initWithTitle:@"ALL_PARTS"delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:@"分享" otherButtonTitles:@"添加到收藏", nil];
//    [sheet showInView:self.view];

    [_tableView setEditing:!_tableView.editing animated:YES];
    
}
@end
