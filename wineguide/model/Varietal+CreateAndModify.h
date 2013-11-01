//
//  Varietal+CreateAndModify.h
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Varietal.h"

@interface Varietal (CreateAndModify)

+(Varietal *)varietalWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;

@end
