//
//  WineDetailsVC.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineDetailsVC.h"
#import "WineDetailsVHTV.h"
#import "WineNameVHTV.h"
#import "Brand.h"
#import "ColorSchemer.h"

@interface WineDetailsVC ()

@property (nonatomic, weak) Wine *wine;
@property (nonatomic, weak) Restaurant *restaurant;
@property (nonatomic, weak) IBOutlet WineDetailsVHTV *wineDetailsVHTV;
@property (nonatomic, weak) IBOutlet WineNameVHTV *wineNameVHTV;
@property (nonatomic, weak) IBOutlet UILabel *numReviewsLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *numFriendsLabel;

@end

@implementation WineDetailsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupWithWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant
{
    self.wine = wine;
    self.restaurant = restaurant;
    
    // [self logDetails];
    
    [self setupTextForWine:wine];
    [self setupFavoriteButton];
    
    [self setupReviewsLabel];
    [self setupNumFriendsLabel];
}

-(void)setupTextForWine:(Wine *)wine
{
    [self.wineNameVHTV setupTextViewWithWine:wine fromRestaurant:self.restaurant];
    [self.wineDetailsVHTV setupTextViewWithWine:wine fromRestaurant:self.restaurant];
}

-(void)setupReviewsLabel
{
    NSString *reviewsText = @"11 reviews";
    NSAttributedString *reviewsAS = [[NSAttributedString alloc] initWithString:reviewsText attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
    self.numReviewsLabel.attributedText = reviewsAS;
}

-(void)setupNumFriendsLabel
{
    NSString *youAndString = @"";
    if([self.wine.favorite boolValue] == YES){
        youAndString = @" you &";
    }
    
    int r = arc4random_uniform(10) + 1;
    NSMutableAttributedString *numFriendsAttributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%@ %i friends liked this",youAndString,r] attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    
    if([self.wine.favorite boolValue] == YES){
        [numFriendsAttributedText addAttribute:NSForegroundColorAttributeName
                                         value:[ColorSchemer sharedInstance].textLink
                                         range:NSMakeRange(2, 3)];
        
        UIFontDescriptor *fontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote];
        UIFontDescriptor *boldFontDescriptor = [fontDesciptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        
        [numFriendsAttributedText addAttribute:NSFontAttributeName
                                         value:[UIFont fontWithDescriptor:boldFontDescriptor size:0]
                                         range:NSMakeRange(2, 3)];
    }
    self.numFriendsLabel.attributedText = numFriendsAttributedText;
}


#pragma mark - Favorites

-(void)setupFavoriteButton
{
    if([self.wine.favorite boolValue] == YES){
        [self.favoriteButton setImage:[UIImage imageNamed:@"button_favorited.png"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"button_favorite.png"] forState:UIControlStateNormal];
    }
}



- (IBAction)favoriteWine:(UIButton *)sender
{
    if([self.wine.favorite boolValue] == YES){
        self.wine.favorite = @NO;
        [self.favoriteButton setImage:[UIImage imageNamed:@"button_favorite.png"] forState:UIControlStateNormal];
        
    } else {
        self.wine.favorite = @YES;
        [self.favoriteButton setImage:[UIImage imageNamed:@"button_favorited.png"] forState:UIControlStateNormal];
    }
    [self.favoriteButton setNeedsDisplay];
}



-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.wine.identifier);
    NSLog(@"alcoholPercentage = %@",self.wine.alcoholPercentage);
    NSLog(@"color = %@",self.wine.color);
    NSLog(@"country = %@",self.wine.country);
    NSLog(@"dessert = %@",self.wine.dessert);
    NSLog(@"favorite = %@",self.wine.favorite);
    NSLog(@"lastServerUpdate = %@",self.wine.lastServerUpdate);
    NSLog(@"deletedEntity = %@",self.wine.deletedEntity);
    NSLog(@"name = %@",self.wine.name);
    NSLog(@"region = %@",self.wine.region);
    NSLog(@"sparkling = %@",self.wine.sparkling);
    NSLog(@"state = %@",self.wine.state);
    NSLog(@"versionNumber = %@",self.wine.versionNumber);
    NSLog(@"vineyard = %@",self.wine.vineyard);
    NSLog(@"vintage = %@",self.wine.vintage);
    
    NSLog(@"brandIdentifier = %@",self.wine.brandIdentifier);
    NSLog(@"wineUnitIdentifiers = %@",self.wine.wineUnitIdentifiers);
    NSLog(@"tastingNoteIdentifers = %@",self.wine.tastingNoteIdentifers);
    NSLog(@"varietalIdentifiers = %@",self.wine.varietalIdentifiers);
    
    NSLog(@"brand = %@",self.wine.brand.description);
    
    NSLog(@"tastingNotes count = %lu",(unsigned long)[self.wine.tastingNotes count]);
    for(NSObject *obj in self.wine.tastingNotes){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"varietals count = %lu",(unsigned long)[self.wine.varietals count]);
    for(NSObject *obj in self.wine.varietals){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"wineUnits = %lu",(unsigned long)[self.wine.wineUnits count]);
    for(NSObject *obj in self.wine.wineUnits){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}


@end
