//
//  TriedItSegue.m
//  Corkie
//
//  Created by Charles Feinn on 12/27/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TriedItSegue.h"

@implementation TriedItSegue

-(void)perform
{
    UIViewController *svc = self.sourceViewController;
    UIViewController *dvc = self.destinationViewController;
    [UIView transitionWithView:svc.navigationController.view duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [svc.navigationController pushViewController:dvc animated:NO];
                    }
                    completion:NULL];
}

@end
