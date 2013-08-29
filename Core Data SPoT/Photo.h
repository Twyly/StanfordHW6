//
//  Photo.h
//  Core Data SPoT
//
//  Created by Teddy Wyly on 8/29/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoKind;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSDate * dateAccessed;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSSet *type;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTypeObject:(PhotoKind *)value;
- (void)removeTypeObject:(PhotoKind *)value;
- (void)addType:(NSSet *)values;
- (void)removeType:(NSSet *)values;

@end
