//
//  Review.m
//  Corkie
//
//  Created by Charles Feinn on 1/6/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Review.h"
#import "Restaurant.h"
#import "TastingRecord.h"
#import "User.h"
#import "Wine.h"


@implementation Review

@dynamic dateAdded;
@dynamic reviewText;
@dynamic identifier;
@dynamic deletedEntity;
@dynamic rating;
@dynamic lastLocalUpdate;
@dynamic lastServerUpdate;
@dynamic wine;
@dynamic user;
@dynamic restaurant;
@dynamic tastingRecord;

@end
