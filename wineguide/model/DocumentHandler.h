//
//  DocumentHandler.h
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onDocumentReady) (UIManagedDocument *document);

@interface DocumentHandler : NSObject

@property (nonatomic, strong) UIManagedDocument *document;

+(DocumentHandler *)sharedDocumentHandler;
-(void)performWithDocument:(onDocumentReady)onDocumentReady;

@end
