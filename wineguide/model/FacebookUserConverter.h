//
//  FacebookUserConverter.h
//  Corkie
//
//  Created by Charles Feinn on 5/28/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FacebookUserConverter : NSObject

-(void)modifyMeWithFacebookDictionary:(NSDictionary *)facebookDictionary;
-(NSManagedObject *)createOrModifyObjectWithFacebookDictionary:(NSDictionary *)facebookDictionary;

@end
