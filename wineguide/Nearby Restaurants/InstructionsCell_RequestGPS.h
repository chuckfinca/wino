//
//  InstructionsCell_RequestGPS.h
//  Corkie
//
//  Created by Charles Feinn on 5/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RequestUserLocation

-(void)requestUserLocationUserRequested:(BOOL)userRequested;

@end

@interface InstructionsCell_RequestGPS : UITableViewCell

@property (nonatomic, weak) id <RequestUserLocation> delegate;

@end
