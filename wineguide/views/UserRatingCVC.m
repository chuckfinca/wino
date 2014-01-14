//
//  UserRatingReusableView.m
//  Corkie
//
//  Created by Charles Feinn on 12/19/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "UserRatingCVC.h"
#import "ColorSchemer.h"

@interface UserRatingCVC ()

@property (nonatomic, strong) UIImage *unrated;
@property (nonatomic, strong) UIImage *rated;

@end


@implementation UserRatingCVC

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - Getters & Setters

-(UIImage *)unrated
{
    if(!_unrated) {
        _unrated = [[UIImage imageNamed:@"glass_empty.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return _unrated;
}

-(UIImage *)rated
{
    if(!_rated) {
        _rated = [[UIImage imageNamed:@"glass_full.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    };
    return _rated;
}


-(void)glassColorString:(NSString *)string isEmpty:(BOOL)glassIsEmpty
{
    UIImage *glass;
    if(glassIsEmpty){
        glass = self.unrated;
        self.ratingImageView.tintColor = [ColorSchemer sharedInstance].gray;
    } else {
        glass = self.rated;
        if([string isEqualToString:@"red"]){
            self.ratingImageView.tintColor = [ColorSchemer sharedInstance].redWine;
        } else if([string isEqualToString:@"rose"]){
            self.ratingImageView.tintColor = [ColorSchemer sharedInstance].roseWine;
        } else if([string isEqualToString:@"white"]){
            self.ratingImageView.tintColor = [ColorSchemer sharedInstance].whiteWine;
        }
    }
    [self.ratingImageView setImage:glass];
    self.backgroundColor = [UIColor clearColor];
}

@end
