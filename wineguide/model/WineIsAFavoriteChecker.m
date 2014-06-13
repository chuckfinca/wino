//
//  WineIsAFavoriteChecker.m
//  Corkie
//
//  Created by Charles Feinn on 6/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineIsAFavoriteChecker.h"
#import "User2.h"
#import "GetMe.h"
#import "Review2.h"

#define REVIEW_ENTITY @"Review2"

@interface WineIsAFavoriteChecker ()

@property (nonatomic, strong) User2 *me;

@end

@implementation WineIsAFavoriteChecker


#pragma mark - Getters & setters

-(User2 *)me
{
    if(!_me){
        _me  = [GetMe sharedInstance].me;
    }
    return _me;
}


-(void)setFavoriteStatusForWine:(Wine2 *)wine
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:REVIEW_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"user.identifier == %@ AND tastingRecord.wine.identifier == %@",self.me.identifier,wine.identifier];
    
    NSError *error;
    NSArray *matches = [self.me.managedObjectContext executeFetchRequest:request error:&error];
    
    NSLog(@"matches count = %lu",(unsigned long)[matches count]);
    
    NSInteger ratingsSummated = 0;
    
    for(Review2 *r in matches){
        NSLog(@"rating = %@",r.rating);
        ratingsSummated += [r.rating integerValue];
    }
    
    float averageRating = ratingsSummated / [matches count];
    
    NSLog(@"average rating = %f",averageRating);
    
    if(averageRating >= 4){
        wine.user_favorite = @YES;
    } else {
        wine.user_favorite = @NO;
    }
}

@end
