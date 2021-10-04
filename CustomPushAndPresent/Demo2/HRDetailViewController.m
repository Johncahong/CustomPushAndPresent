//
//  HRDetailViewController.m
//  CustomPushAndPresent
//
//  Created by Hello Cai on 2021/10/1.
//

#import "HRDetailViewController.h"
#import "HRPresentAnimatedTransitioning.h"

@interface HRDetailViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation HRDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor purpleColor];
    [self setupView];
}


-(void)setupView{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 530)];
    imageview.center = self.view.center;
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.image = [UIImage imageNamed:@"002"];
    [self.view addSubview:imageview];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-80, [UIApplication sharedApplication].statusBarFrame.size.height+5, 60, 30)];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setBackgroundColor:[UIColor systemOrangeColor]];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)buttonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//present过渡动画(非交互)
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    HRPresentAnimatedTransitioning *obj = [[HRPresentAnimatedTransitioning alloc] initType:PictureTransitionPresent];
    return obj;
}

//dismiss过渡动画(非交互)
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    HRPresentAnimatedTransitioning *obj = [[HRPresentAnimatedTransitioning alloc] initType:PictureTransitionDismiss];
    return obj;
}

@end
