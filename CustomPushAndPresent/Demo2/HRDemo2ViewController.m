//
//  HRDemo2ViewController.m
//  CustomPushAndPresent
//
//  Created by Hello Cai on 2021/9/30.
//

#import "HRDemo2ViewController.h"
#import "HRDetailViewController.h"

@interface HRDemo2ViewController ()
@end

@implementation HRDemo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PresetDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupView];
}


-(void)setupView{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 530)];
    imageview.center = self.view.center;
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.image = [UIImage imageNamed:@"001"];
    [self.view addSubview:imageview];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    button.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-100);
    [button setTitle:@"点击展示下一页" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setBackgroundColor:[UIColor systemOrangeColor]];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)buttonClick{
    HRDetailViewController *vc = [[HRDetailViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
