//
//  Entry+CoreDataProperties.h
//  BoomProject
//
//  Created by User ACA on 3/31/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "Entry+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entry (CoreDataProperties)

+ (NSFetchRequest<Entry *> *)fetchRequest;
+ (NSString *)relativeDateStringForDate:(NSDate *)date;

@property (nonatomic) double entryID;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, retain) Form *form;
@property (nullable, nonatomic, retain) NSSet<Row *> *rows;

@end

@interface Entry (CoreDataGeneratedAccessors)

- (void)addRowsObject:(Row *)value;
- (void)removeRowsObject:(Row *)value;
- (void)addRows:(NSSet<Row *> *)values;
- (void)removeRows:(NSSet<Row *> *)values;

@end

NS_ASSUME_NONNULL_END
