//
//  UserListCell.h
//  Corkie
//
//  Created by Charles Feinn on 6/11/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListCell : UITableViewCell

-(void)setupUserInteractionEnabled:(BOOL)userInteractionEnabled cellWithTitle:(NSString *)title;

@end
