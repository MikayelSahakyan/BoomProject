//
//  EntryModel.m
//  BoomProject
//
//  Created by User ACA on 2/24/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "EntryModel.h"

@implementation EntryModel

- (instancetype)initWithResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    if (self) {
        
        self.ID = [responseObject objectForKey:@"id"];
        self.date = [responseObject objectForKey:@"date"];
        self.key = [responseObject objectForKey:@"key"];
        self.value = [responseObject objectForKey:@"value"];
        self.rowID = [responseObject objectForKey:@"row_id"];
    }
    return self;
}

@end
