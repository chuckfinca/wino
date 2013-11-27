//
//  LocalObjectUpdater.h
//  Gimme
//
//  Created by Charles Feinn on 11/27/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalObjectUpdater : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;

-(void)updateTastingNotesAndVarietals;

@end
