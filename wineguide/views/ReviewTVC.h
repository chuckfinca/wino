//
//  ReviewTVC.h
//  Corkie
//
//  Created by Charles Feinn on 12/26/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *userImageButton;
@property (weak, nonatomic) IBOutlet UIButton *userNameButton;
@property (weak, nonatomic) IBOutlet UIButton *followUserButton;

-(void)setupReviewForWineColor:(NSString *)wineColor;

@end
