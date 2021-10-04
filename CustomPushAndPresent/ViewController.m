//
//  ViewController.m
//  CustomPushAndPresent
//
//  Created by Hello Cai on 2021/9/30.
//

#import "ViewController.h"
#import "HRDemo1ViewController.h"
#import "HRDemo2ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
    [self setupView];
}

-(void)setupView{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,120, 50)];
    btn.center = CGPointMake(self.view.center.x, self.view.center.y-50);
    [btn setTitle:@"自定义Push" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor systemOrangeColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,120, 50)];
    btn2.center = CGPointMake(self.view.center.x, self.view.center.y+50);
    [btn2 setTitle:@"自定义Preset" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(presentClick) forControlEvents:UIControlEventTouchUpInside];
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn2 setBackgroundColor:[UIColor systemOrangeColor]];
    [self.view addSubview:btn2];
}

-(void)pushClick{
    HRDemo1ViewController *vc = [[HRDemo1ViewController alloc] init];
    vc.imageName = @"001";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)presentClick{
    HRDemo2ViewController *vc = [[HRDemo2ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
