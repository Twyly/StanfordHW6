//
//  Photo+Flickr.m
//  Core Data SPoT
//
//  Created by Teddy Wyly on 8/29/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "PhotoKind+Create.h"


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
        photo.squareImageURL = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString];
        photo.alphabeticalSection = [[photo.title substringToIndex:1] capitalizedString];
        photo.deleted = [NSNumber numberWithBool:NO];
        photo.unique = [photoDictionary[FLICKR_PHOTO_ID] description];
        
        // SETTING KIND
        NSArray *photoTags = [photoDictionary[FLICKR_TAGS] componentsSeparatedByString:@" "];
        NSMutableSet *allKinds = [[NSMutableSet alloc] init];
        for (NSString *tag in photoTags) {
            if (![[Photo invalidTags] containsObject:tag]) {
                PhotoKind *kind = [PhotoKind photoKindWithName:tag withContext:context];
                [allKinds addObject:kind];
            }
        }
        // Add the All tag
        [allKinds addObject:[PhotoKind photoKindWithName:@"All" withContext:context]];
        photo.kinds = allKinds;
        // END SETTING KIND
        
    } else {
        photo = [matches lastObject];
    }
    
    return photo;
}


+ (NSArray *)invalidTags
{
    return @[@"cs193pspot", @"portrait", @"landscape"];
}

@end
