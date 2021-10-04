//
//  HRDemo1ViewController.m
//  CustomPushAndPresent
//
//  Created by Hello Cai on 2021/9/30.
//

#import "HRDemo1ViewController.h"

@interface HRDemo1ViewController ()

@end

@implementation HRDemo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PushDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupView];
}

-(void)setupView{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 530)];
    imageview.center = self.view.center;
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.image = [UIImage imageNamed:self.imageName];
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
    HRDemo1ViewController *vc = [[HRDemo1ViewController alloc] init];
    int index = [self.imageName intValue] + 1;
    if (index == 5) {
        index = 1;
    }
    
    vc.imageName = [NSString stringWithFormat:@"%03d", index];
    if (index == 3) {
        //展示自定义转场
//        vc.hr_addTransitionFlag = YES;
        vc.hr_addTransitionFlag = NO;
    }else{
        vc.hr_addTransitionFlag = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    NSLog(@"%s", __func__);
}
@end
