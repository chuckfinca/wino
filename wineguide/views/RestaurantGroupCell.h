//
//  RestaurantGroupCell.h
//  Gimme
//
//  Created by Charles Feinn on 12/13/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"

@interface RestaurantGroupCell : UITableViewCell


-(void)setupCellAtIndexPath:(NSIndexPath *)indexPath forGroup:(Group *)group;

@end
