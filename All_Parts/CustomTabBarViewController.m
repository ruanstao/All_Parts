//
//  CustomTabBarViewController.m
//  All_Parts
//
//  Created by RuanSTao on 14-2-19.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import "CustomTabBarViewController.h"
#define TabBarBackgroundImageViewTag 11111
@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init {
    self = [super init];
    if (self) {
//        self.tabBarBackgroundImage = [UIImage imageNamed:@"topbtn.png"];
//    
//        NSMutableArray *aunSelectedImageArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"home.png"],
//                                                    [UIImage imageNamed:@"content.png"],
//                                                    [UIImage imageNamed:@"question.png"],
//                                                    [UIImage imageNamed:@"things.png"],
//                                                    [UIImage imageNamed:@"shareBtn.png"], nil];
//            self.unSelectedImageArray = aunSelectedImageArray;
//    
//        NSMutableArray *aselectedImageArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"home_hl.png"],
//                                                    [UIImage imageNamed:@"content_hl.png"],
//                                                    [UIImage imageNamed:@"question_hl.png"],
//                                                    [UIImage imageNamed:@"things_hl.png"],
//                                                    [UIImage imageNamed:@"shareBtn_hl.png"], nil];
//            self.selectedImageArray = aselectedImageArray;
//    
//           self.itemBgImageViewArray = [NSMutableArray array];
//            _lastSelectedIndex = 0;
//            _hiddenIndex = -1;
        
    }
    return self;
}
- (id)initWithTabBarBackgroundImage:(UIImage *)barBackgroundImage
               unSelectedImageArray:(NSMutableArray *)unImageArray
                 selectedImageArray:(NSMutableArray *)imageArray {
    self = [super init];
    if (self) {
        
        self.tabBarBackgroundImage = barBackgroundImage;
        self.unSelectedImageArray = unImageArray;
        self.selectedImageArray = imageArray;
    
        self.itemBgImageViewArray = [NSMutableArray array];
        _lastSelectedIndex = 0;
        _hiddenIndex = -1;
    }
    return self;
}
#pragma mark - itemIndex methods

- (void)setLastSelectedIndex:(int)lastSelectedIndex {
    if (_lastSelectedIndex != lastSelectedIndex) {
        //将上次的选中效果取消
        UIImageView *lastSelectedImageView = (UIImageView *)[_itemBgImageViewArray objectAtIndex:_lastSelectedIndex];;
        lastSelectedImageView.image = [_unSelectedImageArray objectAtIndex:_lastSelectedIndex];
        
        _lastSelectedIndex = lastSelectedIndex;
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    //将上次的选中效果取消
    self.lastSelectedIndex = selectedIndex;
    //将本次的选中效果显示
    UIImageView *selectedImageView = (UIImageView *)[_itemBgImageViewArray objectAtIndex:selectedIndex];
    selectedImageView.image = [_selectedImageArray objectAtIndex:selectedIndex];
    
}

//隐藏某个tabBarItem的图片
- (void)hiddeItemImageView:(int)index {
    if (_hiddenIndex != index) {
        _hiddenIndex = index;
        
        UIImageView *hiddenImageView = (UIImageView *)[_itemBgImageViewArray objectAtIndex:_hiddenIndex];
        hiddenImageView.hidden = YES;
    }
}

//显示某个tabBarItem的图片
- (void)showItemImageView:(int)index {
    if (_hiddenIndex == index) {
        
        UIImageView *hiddenImageView = (UIImageView *)[_itemBgImageViewArray objectAtIndex:_hiddenIndex];
        hiddenImageView.hidden = NO;
        
        _hiddenIndex = -1;
    }
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    self.tabBarBackgroundImage = [UIImage imageNamed:@"topbtn.png"];
    
    NSMutableArray *aunSelectedImageArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"home.png"],
                                             [UIImage imageNamed:@"content.png"],
                                             [UIImage imageNamed:@"question.png"],
                                             [UIImage imageNamed:@"things.png"],
                                             [UIImage imageNamed:@"personal.png"], nil];
    self.unSelectedImageArray = aunSelectedImageArray;
    
    NSMutableArray *aselectedImageArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"home_hl.png"],
                                           [UIImage imageNamed:@"content_hl.png"],
                                           [UIImage imageNamed:@"question_hl.png"],
                                           [UIImage imageNamed:@"things_hl.png"],
                                           [UIImage imageNamed:@"personal_hl.png"], nil];
    self.selectedImageArray = aselectedImageArray;
    self.itemBgImageViewArray = [NSMutableArray array];
    _lastSelectedIndex = 0;
    _hiddenIndex = -1;
}
#define ItemWidth 64
#define ItemHeight 44
#define SideMarginX 0
#define SideMarginY 0
#define Spacing 0

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIImageView *tabBarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
    UIImageView *tabBarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tabBarBackgroundImageView.tag = TabBarBackgroundImageViewTag;
    tabBarBackgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    tabBarBackgroundImageView.image = _tabBarBackgroundImage;
    self.tabBar.frame=CGRectMake(0, self.view.bounds.size.height-ItemHeight, 320, ItemHeight);
    [self.tabBar insertSubview:tabBarBackgroundImageView atIndex:0];
    for (int i = 0; i < self.selectedImageArray.count; i++) {
        UIImageView *itemBg  = [[UIImageView alloc] initWithFrame:CGRectMake(SideMarginX +ItemWidth * i + Spacing * i, SideMarginY, ItemWidth, ItemHeight)];
        itemBg.contentMode = UIViewContentModeScaleAspectFit;
        itemBg.image = [_unSelectedImageArray objectAtIndex:i];
        [self.tabBar insertSubview:itemBg atIndex:1];
        [_itemBgImageViewArray addObject:itemBg];
    }
    self.selectedIndex = 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.itemBgImageViewArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    self.selectedIndex = [tabBar.items indexOfObject:item];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
