//
//  FavoritesSCDTVC.h
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "SearchableICDTVC.h"
#import "User.h"

@interface CellarSCDTVC : SearchableICDTVC

-(void)setupForUser:(User *)user;

@end
