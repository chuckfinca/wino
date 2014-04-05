//
//  FavoritesSCDTVC.h
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "SearchableCDTVC.h"
#import "User.h"

@interface CellarSCDTVC : SearchableCDTVC

-(void)setupForUser:(User *)user;

@end
