//
//  Form+CoreDataProperties.m
//  BoomProject
//
//  Created by User ACA on 3/31/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "Form+CoreDataProperties.h"

@implementation Form (CoreDataProperties)

+ (NSFetchRequest<Form *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Form"];
}

@dynamic formID;
@dynamic name;
@dynamic entries;

@end
