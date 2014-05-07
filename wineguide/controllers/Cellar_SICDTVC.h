//
//  FavoritesSCDTVC.h
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Searchable_ICDTVC.h"
#import "User.h"

@interface Cellar_SICDTVC : Searchable_ICDTVC

-(void)setupForUser:(User *)user;

@end
