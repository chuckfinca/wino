//
//  WineDataHelper.h
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "JSONTOCoreDataHelper.h"
#import "Restaurant.h"

@interface WineDataHelper : JSONTOCoreDataHelper

@property (nonatomic, strong) Restaurant *restaurant;

@end
