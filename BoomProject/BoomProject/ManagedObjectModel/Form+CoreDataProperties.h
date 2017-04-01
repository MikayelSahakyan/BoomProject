//
//  Form+CoreDataProperties.h
//  BoomProject
//
//  Created by User ACA on 3/31/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "Form+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface Form (CoreDataProperties)

+ (NSFetchRequest<Form *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *formID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Entry *> *entries;

@end

@interface Form (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSSet<Entry *> *)values;
- (void)removeEntries:(NSSet<Entry *> *)values;

@end

NS_ASSUME_NONNULL_END
