//
//  Photo+Flickr.h
//  Core Data SPoT
//
//  Created by Teddy Wyly on 8/29/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "Photo.h"

#define ALL_PHOTO_KIND_NAME @"^^ALL^^"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)dictionary withContext:(NSManagedObjectContext *)context;


@end
