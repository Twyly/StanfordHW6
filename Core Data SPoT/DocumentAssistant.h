//
//  DocumentAssistant.h
//  Core Data SPoT
//
//  Created by Teddy Wyly on 9/1/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentAssistant : NSObject

@property (strong, nonatomic) UIManagedDocument *document;

+ (DocumentAssistant *)sharedInstance;

- (void)openDocumentWithBlock:(void (^)(BOOL))block;


@end
