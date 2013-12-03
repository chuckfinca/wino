//
//  WineCell.h
//  Gimme
//
//  Created by Charles Feinn on 12/3/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WineUnit.h"

@interface WineCell : UITableViewCell

-(void)setupCellForWineUnit:(WineUnit *)wineUnit;

@end
