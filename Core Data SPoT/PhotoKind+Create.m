//
//  PhotoKind+Create.m
//  Core Data SPoT
//
//  Created by Teddy Wyly on 8/29/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "PhotoKind+Create.h"

@implementation PhotoKind (Create)

+ (PhotoKind *)photoKindWithName:(NSString *)name withContext:(NSManagedObjectContext *)context
{
    PhotoKind *kind = nil;
    
    if (name.length) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PhotoKind"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
        
        if (!matches || [matches count] > 1) {
            //error
        } else if (![matches count]) {
            kind = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoKind" inManagedObjectContext:context];
            kind.name = name;
        } else {
            kind = [matches lastObject];
        }
    }
    return kind;
}

@end
