//
//  ReviewsTVControllerHeaderView.m
//  Corkie
//
//  Created by Charles Feinn on 3/31/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ReviewsTVControllerHeaderView.h"
#import "WineNameVHTV.h"
#import "DateStringFormatter.h"

@interface ReviewsTVControllerHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;

@end


@implementation ReviewsTVControllerHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupWithDate:(NSDate *)date wine:(Wine *)wine andRestaurant:(Restaurant *)restaurant
{
    self.dateLabel.attributedText = [DateStringFormatter attributedStringFromDate:date];
    [self.wineNameVHTV setupTextViewWithWine:wine fromRestaurant:restaurant];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
