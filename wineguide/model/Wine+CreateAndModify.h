//
//  Wine+CreateAndModify.h
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Wine.h"

@interface Wine (CreateAndModify)

+(Wine *)wineFromRestaurant:(Restaurant *)restaurant withInfo:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

@end
