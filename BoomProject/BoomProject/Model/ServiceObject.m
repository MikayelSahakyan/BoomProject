//
//  ServiceObject.m
//  BoomProject
//
//  Created by User ACA on 2/28/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "ServiceObject.h"

@implementation ServiceObject

- (instancetype)initWithResponse:(NSDictionary *)responseObject {
    self = [super init];
    if (self) {
        self.ID = [responseObject objectForKey:@"id"];
    }
    return self;
}

@end
