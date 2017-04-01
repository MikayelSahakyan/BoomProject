//
//  Row+CoreDataProperties.m
//  BoomProject
//
//  Created by User ACA on 3/31/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "Row+CoreDataProperties.h"

@implementation Row (CoreDataProperties)

+ (NSFetchRequest<Row *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Row"];
}

@dynamic key;
@dynamic value;
@dynamic rowID;
@dynamic entry;

@end
