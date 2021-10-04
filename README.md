# CustomPushAndPresent

### 项目概述
- iOS中最常见的动画无疑是Push和Pop的转场动画了，其次是Present和Dismiss的转场动画。   
如果我们想自定义这些转场动画，苹果其实提供了相关的API，在自定义转场之前，我们需要了解转场原理和处理逻辑。下面是自定义转场的效果：

<div align=center><img src="https://raw.githubusercontent.com/Johncahong/CustomPushAndPresent/main/readmeImage/IMG_01.GIF"></div>

- 项目地址：[CustomPushAndPresent](https://github.com/Johncahong/CustomPushAndPresent)   
如果文章和项目对你有帮助，还请给个Star⭐️，你的Star⭐️是我持续输出的动力，谢谢啦😘

### Push/Pop转场
#### Push/Pop转场原理
- 在调用导航控制器的pushViewController:animated:之前，如果设置了导航控制器的delegate对象，就会调用delegate对象的回调方法`navigationController:animationControllerForOperation:fromViewController:toViewController:`，可在该回调方法中自定义转场，该回调方法需要返回一个遵守UIViewControllerAnimatedTransitioning协议的对象，定义一个类实现UIViewControllerAnimatedTransitioning协议的两个方法以便自定义Push/Pop转场，这两个必须实现的方法如下：
```c
@interface HRPushAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning,CAAnimationDelegate>
@property(nonatomic, assign)UINavigationControllerOperation operation;
@end
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext;
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
```
- 用runtime给UIViewController提供一个属性hr_addTransitionFlag，用于标记是否添加自定义转场。代码如下：
```c
@interface UIViewController (TransitionProperty)
@property (nonatomic, assign) BOOL hr_addTransitionFlag;//是否添加自定义转场
@end
    
#import "UIViewController+TransitionProperty.h"
#import <objc/runtime.h>
    
static NSString *hr_addTransitionFlagKey = @"hr_addTransitionFlagKey";
@implementation UIViewController (TransitionProperty)
    
- (void)setHr_addTransitionFlag:(BOOL)hr_addTransitionFlag {
    objc_setAssociatedObject(self, &hr_addTransitionFlagKey, @(hr_addTransitionFlag), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)hr_addTransitionFlag {
    return [objc_getAssociatedObject(self, &hr_addTransitionFlagKey) integerValue] == 0 ?  NO : YES;
}
@end
```
 上面说过只要给导航控制器设置delegate，则调用pushViewController:animated:后，就会执行navigationController:animationControllerForOperation:fromViewController:toViewController:方法，从而展示自定义的Push/Pop转场，调用popViewControllerAnimated:后同理。导航控制器的代码如下：
```c
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    /*给导航控制器设置了delegate，调用pushViewController:animated:后，
      会去执行navigationController:animationControllerForOperation:fromViewController:toViewController:
     */
    self.delegate = (id)viewController;
    [super pushViewController:viewController animated:animated];
}
    
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    /*给导航控制器设置了delegate，调用popViewControllerAnimated:后，
      会去执行navigationController:animationControllerForOperation:fromViewController:toViewController:
     */
    self.delegate = self.viewControllers.lastObject;
    return [super popViewControllerAnimated:animated];
}
```
#### 自定义转场
- 这里自定义一种Push时toView从屏幕顶部往下移动到屏幕中央的转场，Pop时toView从屏幕中央往下移出屏幕的转场。实现代码如下：
```c
#import <UIKit/UIKit.h>
@interface HRPushAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning,CAAnimationDelegate>
@property(nonatomic, assign)UINavigationControllerOperation operation;
@end
    
@implementation HRPushAnimatedTransitioning
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.4;
}
        
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = transitionContext.containerView;
    //containerView本来有fromView，只需添加toView
    [containerView addSubview:toView];
    
    CGRect fromViewStartFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect toViewStartFrame = [transitionContext finalFrameForViewController:toVC];
    
    CGRect fromViewEndFrame = fromViewStartFrame;
    CGRect toViewEndFrame = toViewStartFrame;
    
    if (_operation == UINavigationControllerOperationPush) {
        toViewStartFrame.origin.y -= toViewEndFrame.size.height;
    }else if (_operation == UINavigationControllerOperationPop) {
        fromViewEndFrame.origin.y += fromViewStartFrame.size.height;
        [containerView sendSubviewToBack:toView];
    }
    
    fromView.frame = fromViewStartFrame;
    toView.frame = toViewStartFrame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.frame = fromViewEndFrame;
        toView.frame = toViewEndFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}
```
#### 处理系统的右滑返回手势
- iOS7开始苹果提供了一个滑动返回上一界面的手势，由于我在pushViewController:animated:方法中设置了导航控制器的delegate，导致右滑返回手势失效，解决方式是重新设置右滑返回手势的delegate对象：
```c
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakself = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        /*只要自定义navigationItem的leftBarButtonItem或navigationController，滑动手势会失效。
          因此要重新设置系统自带的右滑返回手势的代理为self
         */
        self.interactivePopGestureRecognizer.delegate = weakself;
    }
}
```
 以上设置后，rootViewController也会响应右滑返回，可能导致一些问题，因此需要禁止rootViewController的右滑返回功能。即导航控制器中的代码如下：
```c
#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        //屏蔽rootViewController的滑动返回手势，避免右滑返回手势引起死机问题
        if (self.viewControllers.count <= 1 || self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    return YES;
}
```
 注意右滑返回手势默认是启用的，即self.interactivePopGestureRecognizer的enable默认是YES

#### 处理右滑返回手势的转场
- 上面虽然实现了自定义Push/Pop转场，但是用系统自带滑动手势pop时并没有展示我们自定义的Push/Pop转场效果，展示的依然是系统默认的转场效果。
原因是当自定义了Push or Pop的转场，系统调用navigationController:animationControllerForOperation:fromViewController:toViewController:方法，该方法**如果返回的是非nil对象后**，就会执行以下代理方法：
```c
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
```
 这是苹果提供给开发者自定义滑动手势交互转场的代理方法，返回一个遵守UIViewControllerInteractiveTransitioning协议的对象，该对象需要实现startInteractiveTransition:方法，为此苹果提供了一个实现该协议的UIPercentDrivenInteractiveTransition类，我们只需定义一个继承UIPercentDrivenInteractiveTransition类的类，就能满足返回对象的条件，而不需要是实现startInteractiveTransition:方法。
由于当navigationController:animationControllerForOperation:fromViewController:toViewController返回的对象非nil时，Push和Pop都会回调`navigationController:interactionControllerForAnimationController:`代理方法，而我们重写该代理方法只是针对右滑返回手势的转场，其他情况返回nil，因此需要区分push还是pop。解决方式是在navigationController:animationControllerForOperation:fromViewController:toViewController中保存当前是push还是pop。代码如下：
```c
//用于自定义Push or Pop的转场
//返回值非nil表示使用自定义的Push or Pop转场。nil表示使用系统默认的转场
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (!self.hr_addTransitionFlag) {
        return nil;
    }
    HRPushAnimatedTransitioning *obj = [[HRPushAnimatedTransitioning alloc] init];
    obj.operation = operation;
    _operation = operation;
    if (operation == UINavigationControllerOperationPush) {
//            NSLog(@"_interactive:%@--%@", _interactive, self);
        if (_interactive == nil) {
            _interactive = [[HRPercentDrivenInteractiveTransition alloc] init];
        }
        [_interactive addGestureToViewController:self];
    }
    return obj;
}
    
//使用自定义的Push or Pop转场才会回调该方法，用于自定义滑动手势的转场交互方式
//返回值非nil表示可交互处理转场进度。nil表示无法交互处理转场进度，直接完成转场
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
        
    if (_operation == UINavigationControllerOperationPush) {
        return nil;
    }else{
        if (_interactive.canInteractive) {
            return  _interactive;
        }else{
            return nil;
        }
    }
}
```

#### 实现自定义右滑返回手势的转场
- HRPercentDrivenInteractiveTransition类的逻辑是：给控制器view添加Pan手势，当右滑时，计算右滑占屏幕宽度的百分比percent（可认为是转场进度参数），然后在右滑开始时，调用导航控制器的popViewControllerAnimated:。滑动过程中调用updateInteractiveTransition:，传入转场进度参数percent。转场结束时根据转场进度，判断是调用finishInteractiveTransition（转场完成，即成功pop到上一界面）还是cancelInteractiveTransition（转场恢复到起点）。最终代码如下：
```c
#import <UIKit/UIKit.h>
//UIPercentDrivenInteractiveTransition实现UIViewControllerInteractiveTransitioning协议
@interface HRPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition
    
@property (readonly, assign, nonatomic) BOOL canInteractive;
-(void)addGestureToViewController:(UIViewController *)vc;    
@end
    
@interface HRPercentDrivenInteractiveTransition ()
@property (nonatomic, weak) UINavigationController *nav;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat percent;
@end
    
@implementation HRPercentDrivenInteractiveTransition
    
-(void)addGestureToViewController:(UIViewController *)vc{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [vc.view addGestureRecognizer:pan];
    self.nav = vc.navigationController;
}
    
-(void)panAction:(UIPanGestureRecognizer *)pan{
    _percent = 0.0;
    CGFloat totalWidth = pan.view.bounds.size.width;
        
    CGFloat x = [pan translationInView:pan.view].x;
    _percent = x/totalWidth;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            _canInteractive = YES;
            [_nav popViewControllerAnimated:YES];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            [self updateInteractiveTransition:_percent];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            _canInteractive = NO;
            [self continueAction];
        }
            break;
        default:
            break;
    }
}
    
-(BOOL)isCanInteractive{
    return _canInteractive;
}
    
- (void)continueAction{
    if (_displayLink) {
        return;
    }
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(UIChange)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
    
- (void)UIChange {
    CGFloat timeDistance = 1.5/60;
    if (_percent > 0.4) {
        _percent += timeDistance;
    }else {
        _percent -= timeDistance;
    }
    [self updateInteractiveTransition:_percent];
    
    if (_percent >= 1.0) {
        //转场完成
        [self finishInteractiveTransition];
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    if (_percent <= 0.0) {
        //转场取消
        [self cancelInteractiveTransition];
        [_displayLink invalidate];
        _displayLink = nil;
    }
}
```

### Present/Dimiss转场
#### Present/Dimiss转场原理
- 控制器设置transitioningDelegate为自身，遵守UIViewControllerTransitioningDelegate协议，实现协议的present动画方法和dismiss动画方法，即如下两个方法：
```c
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;
```
 这两个方法需要返回一个遵守UIViewControllerAnimatedTransitioning协议的对象，定义一个类实现UIViewControllerAnimatedTransitioning协议的两个方法以便自定义Present/Dimiss转场。
控制器关键代码如下：
```c
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
    }
    return self;
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
```

#### 自定义转场
- 这里自定义一种Present时toView从屏幕左边往右移动到屏幕中央的转场，dismiss时toView从屏幕中央往右移出屏幕的转场。实现代码如下：
```c
typedef NS_ENUM(NSInteger,PictureTransitionType) {
    PictureTransitionPresent = 0,//显示
    PictureTransitionDismiss //消失
};
    
@interface HRPresentAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
- (instancetype)initType:(PictureTransitionType)type;
@end
    
#import "HRPresentAnimatedTransitioning.h"
@interface HRPresentAnimatedTransitioning ()
@property(nonatomic, assign)PictureTransitionType type;
@end
    
@implementation HRPresentAnimatedTransitioning
    
- (instancetype)initType:(PictureTransitionType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}
    
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.4;
}
    
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //present时，fromVC是导航控制器，toVC是HRDetailViewController。dismiss时，fromVC是HRDetailViewController，toVC是导航控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = transitionContext.containerView;
    //containerView本来有fromView，只需添加toView
    [containerView addSubview:toView];
        
    CGRect fromViewStartFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect toViewStartFrame = [transitionContext finalFrameForViewController:toVC];
    
    CGRect fromViewEndFrame = fromViewStartFrame;
    CGRect toViewEndFrame = toViewStartFrame;
    
    if (_type == PictureTransitionPresent) {
        toViewStartFrame.origin.x -= toViewEndFrame.size.width;
    }else if (_type == PictureTransitionDismiss) {
        fromViewEndFrame.origin.x += fromViewStartFrame.size.width;
        [containerView sendSubviewToBack:toView];
    }
    
    fromView.frame = fromViewStartFrame;
    toView.frame = toViewStartFrame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.frame = fromViewEndFrame;
        toView.frame = toViewEndFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}
@end
```