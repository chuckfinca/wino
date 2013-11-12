//
//  WineDetailsVC.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineDetailsVC.h"
#import "VariableHeightTV.h"
#import "Varietal.h"
#import "Brand.h"
#import "TastingNote.h"
#import "Restaurant.h"

@interface WineDetailsVC ()

@property (nonatomic, strong) Wine *wine;
@property (nonatomic, weak) IBOutlet VariableHeightTV *wineNameTV;
@property (nonatomic, weak) IBOutlet VariableHeightTV *yearTV;
@property (nonatomic, weak) IBOutlet VariableHeightTV *varietalTV;
@property (nonatomic, weak) IBOutlet VariableHeightTV *regionTV;
@property (nonatomic, weak) IBOutlet VariableHeightTV *alcoholPercentageTV;
@property (nonatomic, weak) IBOutlet UILabel *numReviewsLabel;

@end

@implementation WineDetailsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
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

#define V_HEIGHT 20

-(void)setupWithWine:(Wine *)wine
{
    self.wine = wine;
    
    [self logDetails];
    
    NSString *wineName = @"";
    if([wine.name length] > 0){
        wineName = wine.name;
    } else {
        wineName = wine.brand.name;
    }
    NSAttributedString *name = [[NSAttributedString alloc] initWithString:wineName attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]}];
    [self.wineNameTV setHeightConstraintForAttributedText:[[NSAttributedString alloc] initWithString:wineName] andMinimumHeight:V_HEIGHT];
    self.wineNameTV.attributedText = name;
    
    NSString *vintageString = [NSString stringWithFormat:@"%@",wine.vintage];
    NSAttributedString *vintage = [[NSAttributedString alloc] initWithString:vintageString attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]}];
    [self.yearTV setHeightConstraintForAttributedText:[[NSAttributedString alloc] initWithString:vintageString] andMinimumHeight:V_HEIGHT];
    self.yearTV.attributedText = vintage;
    
    NSString *varietalsString = [NSString stringWithFormat:@"%@ - ",wine.color];
    for(Varietal *v in wine.varietals){
        varietalsString = [varietalsString stringByAppendingString:[NSString stringWithFormat:@"%@, ",v.name]];
    }
    varietalsString = [varietalsString substringToIndex:[varietalsString length]-2];
    NSAttributedString *varietals = [[NSAttributedString alloc] initWithString:varietalsString attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]}];
    [self.varietalTV setHeightConstraintForAttributedText:[[NSAttributedString alloc] initWithString:varietalsString] andMinimumHeight:V_HEIGHT];
    self.varietalTV.attributedText = varietals;
    
    NSString *locationString = [NSString stringWithFormat:@"%@, %@",wine.region, wine.country];
    NSAttributedString *location = [[NSAttributedString alloc] initWithString:locationString attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]}];
    [self.regionTV setHeightConstraintForAttributedText:[[NSAttributedString alloc] initWithString:wine.region] andMinimumHeight:V_HEIGHT];
    self.regionTV.attributedText = location;
    
    NSAttributedString *vineyard = [[NSAttributedString alloc] initWithString:wine.vineyard attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]}];
    [self.alcoholPercentageTV setHeightConstraintForAttributedText:[[NSAttributedString alloc] initWithString:wine.vineyard] andMinimumHeight:V_HEIGHT];
    self.alcoholPercentageTV.attributedText = vineyard;
    
    [self setupReviewsLabel];
}

-(void)setupReviewsLabel
{
    NSString *reviewsText = @"11 reviews";
    NSAttributedString *reviewsAS = [[NSAttributedString alloc] initWithString:reviewsText attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]}];
    self.numReviewsLabel.attributedText = reviewsAS;
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
    NSLog(@"lastAccessed = %@",self.wine.lastAccessed);
    NSLog(@"markForDeletion = %@",self.wine.markForDeletion);
    NSLog(@"name = %@",self.wine.name);
    NSLog(@"region = %@",self.wine.region);
    NSLog(@"sparkling = %@",self.wine.sparkling);
    NSLog(@"state = %@",self.wine.state);
    NSLog(@"version = %@",self.wine.version);
    NSLog(@"vineyard = %@",self.wine.vineyard);
    NSLog(@"vintage = %@",self.wine.vintage);
    
    NSLog(@"brandIdentifier = %@",self.wine.brandIdentifier);
    NSLog(@"wineUnitIdentifiers = %@",self.wine.wineUnitIdentifiers);
    NSLog(@"tastingNoteIdentifers = %@",self.wine.tastingNoteIdentifers);
    NSLog(@"varietalIdentifiers = %@",self.wine.varietalIdentifiers);
    
    NSLog(@"brand = %@",self.wine.brand.description);
    
    NSLog(@"tastingNotes count = %i",[self.wine.tastingNotes count]);
    for(NSObject *obj in self.wine.tastingNotes){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"varietals count = %i",[self.wine.varietals count]);
    for(NSObject *obj in self.wine.varietals){
        NSLog(@"  %@",obj.description);
    }
    
    NSLog(@"wineUnits = %i",[self.wine.wineUnits count]);
    for(NSObject *obj in self.wine.wineUnits){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}


@end
