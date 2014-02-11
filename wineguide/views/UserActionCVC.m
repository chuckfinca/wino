//
//  UserActionCVC.m
//  Corkie
//
//  Created by Charles Feinn on 12/20/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "UserActionCVC.h"
#import "ColorSchemer.h"


@interface UserActionCVC ()

@property (nonatomic) int index;
@property (weak, nonatomic) IBOutlet UIImageView *actionImageView;
@property (weak, nonatomic) IBOutlet UILabel *actionTitle;
@property (nonatomic, strong) UIImage *triedItImage;
@property (nonatomic, strong) UIImage *cellarImage;
@property (nonatomic, strong) UIImage *cellaredImage;
@property (nonatomic, strong) UIImage *purchaseImage;


@end


@implementation UserActionCVC

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)setupCellForWine:(Wine *)wine atIndex:(NSInteger)index
{
    UIImage *image;
    NSString *title = @"";
    switch (index) {
        case 0:
            image = self.triedItImage;
            title = @"Tried It";
            break;
        case 1:
            if([wine.favorite boolValue] == YES){
                image = self.cellaredImage;
                title = @"Stored";
            } else {
                image = self.cellarImage;
                title = @"Cellar";
            }
            break;
        case 2:
            image = self.purchaseImage;
            title = @"Buy";
            break;
            
        default:
            break;
    }
    [self.actionImageView setImage:image];
    
    self.actionTitle.attributedText = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].clickable}];
    
    self.actionImageView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    self.actionImageView.tintColor = [ColorSchemer sharedInstance].clickable;
    self.actionTitle.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

#pragma mark - Getters & Setters

-(UIImage *)triedItImage
{
    if(!_triedItImage) _triedItImage = [[UIImage imageNamed:@"userAction_triedIt.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return _triedItImage;
}

-(UIImage *)cellarImage
{
    if(!_cellarImage) _cellarImage = [[UIImage imageNamed:@"userAction_cellar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return _cellarImage;
}

-(UIImage *)cellaredImage
{
    if(!_cellaredImage) _cellaredImage = [[UIImage imageNamed:@"userAction_cellared.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return _cellaredImage;
}

-(UIImage *)purchaseImage
{
    if(!_purchaseImage) _purchaseImage = [[UIImage imageNamed:@"userAction_purchase.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return _purchaseImage;
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
