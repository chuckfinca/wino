//
//  TransitionAnimator.m
//  Corkie
//
//  Created by Charles Feinn on 1/9/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TransitionAnimator_CheckInVC.h"

#define CHECK_IN_VC_VIEW_HEIGHT 230

@implementation TransitionAnimator_CheckInVC

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSLog(@"transitionDuration...");
    return 0.5f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSLog(@"animateTransition transition");
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = CGRectMake(10, 20, 300, CHECK_IN_VC_VIEW_HEIGHT);
    
    if(self.presenting){
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = endFrame;
        startFrame.origin.y +=440;
        
        toViewController.view.frame = startFrame;
        toViewController.view.alpha = 0.0;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.alpha = 0.5;
            toViewController.view.frame = endFrame;
            toViewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        NSLog(@"dismiss transition");
        toViewController.view.userInteractionEnabled = YES;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        endFrame.origin.y += 500;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toViewController.view.alpha = 1.0;
            fromViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
        }];
    }
}









@end
