//
//  Row+CoreDataProperties.h
//  BoomProject
//
//  Created by User ACA on 3/31/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "Row+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface Row (CoreDataProperties)

+ (NSFetchRequest<Row *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *key;
@property (nullable, nonatomic, copy) NSString *value;
@property (nullable, nonatomic, copy) NSString *rowID;
@property (nullable, nonatomic, retain) Entry *entry;

@end

NS_ASSUME_NONNULL_END
