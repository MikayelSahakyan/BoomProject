//
//  ServiceObject+CoreDataProperties.m
//  BoomProject
//
//  Created by User ACA on 3/31/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "ServiceObject+CoreDataProperties.h"

@implementation ServiceObject (CoreDataProperties)

+ (NSFetchRequest<ServiceObject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ServiceObject"];
}

@dynamic index;

@end
