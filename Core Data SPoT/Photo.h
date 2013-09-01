//
//  Photo.h
//  Core Data SPoT
//
//  Created by Teddy Wyly on 8/30/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoKind;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSDate * dateAccessed;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSData * squareImageData;
@property (nonatomic, retain) NSString * squareImageURL;
@property (nonatomic, retain) NSSet *kinds;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addKindsObject:(PhotoKind *)value;
- (void)removeKindsObject:(PhotoKind *)value;
- (void)addKinds:(NSSet *)values;
- (void)removeKinds:(NSSet *)values;

@end
