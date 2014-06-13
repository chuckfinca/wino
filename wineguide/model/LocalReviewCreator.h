//
//  LocalReviewCreator.h
//  Corkie
//
//  Created by Charles Feinn on 6/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Review2.h"
#import "User2.h"

@interface LocalReviewCreator : NSObject

-(Review2 *)createClaimed:(BOOL)claimed reviewForUser:(User2 *)user withReviewText:(NSString *)reviewText rating:(float)rating andCreationDate:(NSDate *)creationDate;

@end
