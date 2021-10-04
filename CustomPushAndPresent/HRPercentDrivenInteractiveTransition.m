//
//  HRPercentDrivenInteractiveTransition.m
//  CustomPushAndPresent
//
//  Created by Hello Cai on 2021/10/2.
//

#import "HRPercentDrivenInteractiveTransition.h"

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


@end
