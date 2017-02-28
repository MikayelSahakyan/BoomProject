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

@end
