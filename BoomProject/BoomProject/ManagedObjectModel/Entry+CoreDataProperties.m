//
//  Entry+CoreDataProperties.m
//  BoomProject
//
//  Created by User ACA on 3/31/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "Entry+CoreDataProperties.h"

@implementation Entry (CoreDataProperties)

+ (NSFetchRequest<Entry *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Entry"];
}

+ (NSString *)relativeDateStringForDate:(NSDate *)date {
    
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:units
                                    fromDate:date
                                    toDate:[NSDate date]
                                    options:0];
    if (components.year > 0) {
        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    } else if (components.weekOfYear > 0) {
        return [NSString stringWithFormat:@"%ld week ago", (long)components.weekOfYear];
    } else if (components.day > 0) {
        if (components.day > 1) {
            return [NSString stringWithFormat:@"%ld years ago", (long)components.day];
        } else {
            return @"Yesterday";
        }
    } else {
        return @"Today";
    }
}

@dynamic entryID;
@dynamic date;
@dynamic form;
@dynamic rows;

@end
