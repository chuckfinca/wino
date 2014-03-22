//
//  TransitioningAnimator_CheckInFriends.m
//  Corkie
//
//  Created by Charles Feinn on 3/20/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TransitionAnimator_CheckInFriends.h"

#define CHECK_IN_VC_VIEW_HEIGHT 230
#define HEIGHT_MARGIN 20

@implementation TransitionAnimator_CheckInFriends

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSLog(@"transitionDuration...");
    return 0.5f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSLog(@"animateTransition transition");
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromVC.view.frame = initialFrame;
    toVC.view.frame = initialFrame;
    
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/CGRectGetHeight(initialFrame);
    [containerView.layer setSublayerTransform:transform];
    
    CGFloat direction = self.presenting ? 1.0 : -1.0;
    
    toVC.view.layer.transform = CATransform3DMakeRotation(-direction * M_PI_2, 0, 1, 0);
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext]
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    fromVC.view.layer.transform = CATransform3DMakeRotation(direction * M_PI_2, 0, 1, 0);
                                                                    
                                                                    float height = ([UIScreen mainScreen].bounds.size.height - HEIGHT_MARGIN * 2 - initialFrame.size.height) / 2 + initialFrame.size.height;
                                                                    
                                                                    toVC.view.frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, initialFrame.size.width, height);
                                                                }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5 animations:^{
                                                              toVC.view.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0);
                                                              
                                                              float height;
                                                              if(self.presenting){
                                                                  height = [UIScreen mainScreen].bounds.size.height - 40;
                                                              } else {
                                                                  height = CHECK_IN_VC_VIEW_HEIGHT;
                                                              }
                                                              
                                                              toVC.view.frame = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, initialFrame.size.width, height);
                                                          }];
                                  
                              } completion:^(BOOL finished) {
                                  [transitionContext completeTransition:YES];
                              }];
}






@end
