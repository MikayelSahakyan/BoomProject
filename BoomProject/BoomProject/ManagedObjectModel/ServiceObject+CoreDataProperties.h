//
//  ServiceObject+CoreDataProperties.h
//  BoomProject
//
//  Created by User ACA on 3/31/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "ServiceObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ServiceObject (CoreDataProperties)

+ (NSFetchRequest<ServiceObject *> *)fetchRequest;

@property (nonatomic) int64_t index;

@end

NS_ASSUME_NONNULL_END
