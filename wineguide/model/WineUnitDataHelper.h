//
//  WineUnitDataHelper.h
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "JSONToCoreDataHelper.h"

@interface WineUnitDataHelper : JSONToCoreDataHelper

-(void)createWineUnitWithIdentifier:(NSString *)identifier price:(NSNumber *)price quantity:(NSString *)quantity flightIdentifiers:(NSString *)flightIdentifiers groupIdentifiers:(NSString *)groupIdentifiers andWineIdentifier:(NSString *)wineIdentifier;

@end
