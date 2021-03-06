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
    
    NSCalendarUnit units = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitMonth | NSCalendarUnitYear;
    
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
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    } else if (components.day > 0) {
        if (components.day > 1) {
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        } else {
            return @"Yesterday";
        }
    } else if (components.hour > 0) {
        return [NSString stringWithFormat:@"%ld hours ago", (long)components.hour];
    } else if (components.minute > 0) {
        return [NSString stringWithFormat:@"%ld minutes ago", (long)components.minute];
    } else {
        return [NSString stringWithFormat:@"%ld seconds ago", (long)components.second];
    }
}

@dynamic entryID;
@dynamic date;
@dynamic form;
@dynamic rows;

@end
