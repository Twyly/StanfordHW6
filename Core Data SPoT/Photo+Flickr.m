//
//  Photo+Flickr.m
//  Core Data SPoT
//
//  Created by Teddy Wyly on 8/29/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"


@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary withContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"unique = %@", photoDictionary[FLICKR_PHOTO_ID]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!matches || [matches count] > 1) {
        // errors
    } else if ([matches count] == 0) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.title = [photoDictionary[FLICKR_PHOTO_TITLE] description];
        photo.subtitle = [[photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] description];
        photo.imageURL = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        photo.dateAccessed = [NSDate date];
        photo.unique = [photoDictionary [FLICKR_PHOTO_ID] description];
        
        NSMutableArray *kinds = [[photoDictionary[FLICKR_TAGS] componentsSeparatedByString:@" "] mutableCopy];
        for (NSString *tag in kinds) {
            if ([@[@"cs193pspot", @"portrait", @"landscape"] containsObject:tag]) {
                [kinds removeObject:tag];
            }
        }
        NSSet *set = [NSSet setWithArray:kinds];
        photo.kinds = set;
        
    } else {
        photo = [matches lastObject];
    }
    
    return photo;
}


- (NSArray *)invalideTags
{
    return @[@"cs193pspot", @"portrait", @"landscape"];
}

@end
