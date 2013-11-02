//
//  Brand+CreateAndModify.h
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Brand.h"

@interface Brand (CreateAndModify)

+(Brand *)brandWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;

@end
