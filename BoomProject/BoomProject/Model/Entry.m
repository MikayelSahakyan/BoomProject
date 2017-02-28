//
//  Entry.m
//  BoomProject
//
//  Created by User ACA on 2/28/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "Entry.h"

@implementation Entry

- (instancetype)initWithResponse:(NSDictionary *)responseObject {
    self = [super initWithResponse:responseObject];
    if (self) {
        self.date = [responseObject objectForKey:@"date"];
        self.key = [responseObject objectForKey:@"key"];
        self.value = [responseObject objectForKey:@"value"];
        self.rowID = [responseObject objectForKey:@"row_id"];
    }
    return self;
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

@end
