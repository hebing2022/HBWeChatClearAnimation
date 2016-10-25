//
//  ViewController.m
//  HBWeChatClearAnimation
//
//  Created by hebing on 16/10/25.
//  Copyright © 2016年 hebing. All rights reserved.
//

#import "ViewController.h"
#import "ClearView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) ClearView *clearView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupClearView];

}
- (void)setupClearView
{
    self.clearView = [[ClearView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    [self.view addSubview:self.clearView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
