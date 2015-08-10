//
//  ViewController.m
//  GCCalenderDemo
//
//  Created by 辰 宫 on 15/8/6.
//  Copyright © 2015年 辰 宫. All rights reserved.
//

#import "ViewController.h"
#import "GCCalenderView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    GCCalenderView *calenderView = [[GCCalenderView alloc] initWithFrame:CGRectMake(0, 0, GCC_SCREEN_WIDTH, GCC_SCREEN_HEIGHT)];
    [self.view addSubview:calenderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
