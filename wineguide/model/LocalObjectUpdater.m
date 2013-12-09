//
//  LocalObjectUpdater.m
//  Gimme
//
//  Created by Charles Feinn on 11/27/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "LocalObjectUpdater.h"
#import "TastingNoteDataHelper.h"
#import "VarietalDataHelper.h"
#import "BrandDataHelper.h"

@implementation LocalObjectUpdater

-(void)updateTastingNotesAndVarietals
{
    [self updateTastingNotes];
    [self updateVarietals];
    
    // FOR PRE-HEROKU USE ONLY
    [self updateBrands];
}

-(void)updateTastingNotes
{
    NSURL *tastingNoteJSONUrl = [[NSBundle mainBundle] URLForResource:@"tastingnotes" withExtension:@"json"];
    TastingNoteDataHelper *tndh = [[TastingNoteDataHelper alloc] initWithContext:self.context andRelatedObject:nil andNeededManagedObjectIdentifiersString:nil];
    [tndh updateCoreDataWithJSONFromURL:tastingNoteJSONUrl];
}

-(void)updateVarietals
{
    NSURL *varietalsJSONUrl = [[NSBundle mainBundle] URLForResource:@"varietals" withExtension:@"json"];
    VarietalDataHelper *vdh = [[VarietalDataHelper alloc] initWithContext:self.context andRelatedObject:nil andNeededManagedObjectIdentifiersString:nil];
    [vdh updateCoreDataWithJSONFromURL:varietalsJSONUrl];
}

// FOR PRE-HEROKU USE ONLY

-(void)updateBrands
{
    NSURL *brandsJSONUrl = [[NSBundle mainBundle] URLForResource:@"brands" withExtension:@"json"];
    BrandDataHelper *bdh = [[BrandDataHelper alloc] initWithContext:self.context andRelatedObject:nil andNeededManagedObjectIdentifiersString:nil];
    [bdh updateCoreDataWithJSONFromURL:brandsJSONUrl];
}


@end
