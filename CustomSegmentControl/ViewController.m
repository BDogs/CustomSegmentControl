//
//  ViewController.m
//  CustomSegmentControl
//
//  Created by 诸葛游 on 16/6/6.
//  Copyright © 2016年 fengYeHen. All rights reserved.
//

#import "ViewController.h"
#import "SimpleSegment.h"

@interface ViewController ()
//@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"~~~~~");
    SimpleSegment *seg = [[SimpleSegment alloc] initWithFrame:CGRectMake(50, 100, 200, 40)];
    seg.font = [UIFont systemFontOfSize:15];
    seg.itemTitles = @[@"推荐", @"通知", @"局内", @"资讯指"];
    [self.view addSubview:seg];
    seg.defautColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
