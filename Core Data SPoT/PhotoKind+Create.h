//
//  PhotoKind+Create.h
//  Core Data SPoT
//
//  Created by Teddy Wyly on 8/29/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "PhotoKind.h"

@interface PhotoKind (Create)

+ (PhotoKind *)photoKindWithName:(NSString *)name withContext:(NSManagedObjectContext *)context;

@end
