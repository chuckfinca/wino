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
#import "WineUnit.h"

@interface WineDetailsVC ()

@property (nonatomic, weak) Wine *wine;
@property (nonatomic, weak) Restaurant *restaurant;
@property (nonatomic, weak) IBOutlet VariableHeightTV *wineNameTV;
@property (nonatomic, weak) IBOutlet UILabel *numReviewsLabel;

@end

@implementation WineDetailsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
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

-(void)setupWithWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant
{
    self.wine = wine;
    self.restaurant = restaurant;
    
    [self logDetails];
    
    [self setupTextForWine:wine];
    
    [self setupReviewsLabel];
}

-(void)setupTextForWine:(Wine *)wine
{
    NSString *textViewString = @"";
    NSRange nameRange = NSMakeRange(0, 0);
    NSRange vintageRange = NSMakeRange(0, 0);
    NSRange varietalRange = NSMakeRange(0, 0);
    NSRange regionRange = NSMakeRange(0, 0);
    NSRange countryRange = NSMakeRange(0, 0);
    NSRange vineyardRange = NSMakeRange(0, 0);
    NSRange restaurantRange = NSMakeRange(0, 0);
    
    if(wine.name){
        nameRange = NSMakeRange([textViewString length], [wine.name length]);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@",[wine.name capitalizedString]]];
    }
    if(wine.vintage){
        NSString *vintageString = [wine.vintage stringValue];
        vintageRange = NSMakeRange([textViewString length], [vintageString length]);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"\n%@",[vintageString capitalizedString]]];
    }
    if(wine.varietals){
        NSString *varietalsString = @" - ";
        for(Varietal *varietal in wine.varietals){
            varietalsString = [varietalsString stringByAppendingString:[NSString stringWithFormat:@"%@, ",varietal.name]];
        }
        varietalsString = [varietalsString substringToIndex:[varietalsString length]-2];
        varietalRange = NSMakeRange([textViewString length]+1, [varietalsString length]);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@",[varietalsString capitalizedString]]];
    }
    if(wine.region){
        regionRange = NSMakeRange([textViewString length]+1, [wine.region length]);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"\n%@",[wine.region capitalizedString]]];
    }
    if(wine.country){
        if(wine.region){
            textViewString = [textViewString stringByAppendingString:@", "];
        } else {
            textViewString = [textViewString stringByAppendingString:@"\n"];
        }
        countryRange = NSMakeRange([textViewString length]+1, [wine.country length]);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@",[wine.country capitalizedString]]];
    }
    if(wine.vineyard){
        vineyardRange = NSMakeRange([textViewString length]+1, [wine.vineyard length]);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"\n%@",[wine.vineyard capitalizedString]]];
    }
    if(wine.alcoholPercentage){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"\n%@%% Alcohol",[wine.alcoholPercentage stringValue]]];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY groups.restaurantIdentifier == %@",self.restaurant.identifier];
    
    NSSet *wineUnits = [wine.wineUnits filteredSetUsingPredicate:predicate];
    if(wineUnits){
        restaurantRange = NSMakeRange([textViewString length], [self.restaurant.name length]+4);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"\n\n%@: ",[self.restaurant.name capitalizedString]]];
        
        NSString * wineUnitsString = @" ";
        for(WineUnit *wineUnit in wineUnits){
            wineUnitsString = [NSString stringWithFormat:@"$%@ %@, ",[wineUnit.price stringValue],wineUnit.quantity];
        }
        wineUnitsString = [wineUnitsString substringToIndex:[wineUnitsString length]-2];
        textViewString = [textViewString stringByAppendingString:wineUnitsString];
    }
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:textViewString];
    self.wineNameTV.attributedText = attributedText;
    self.wineNameTV.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
    [self.wineNameTV.textStorage addAttribute:NSFontAttributeName
                                              value:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                                              range:nameRange];
    [self.wineNameTV.textStorage addAttribute:NSForegroundColorAttributeName
                                        value:[UIColor grayColor]
                                        range:restaurantRange];
    
    [self.wineNameTV setHeightConstraintForAttributedText:self.wineNameTV.textStorage andMinimumHeight:V_HEIGHT];
    
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
