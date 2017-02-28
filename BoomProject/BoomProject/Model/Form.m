//
//  Form.m
//  BoomProject
//
//  Created by User ACA on 2/28/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "Form.h"

@implementation Form

- (instancetype)initWithResponse:(NSDictionary *)responseObject {
    self = [super initWithResponse:responseObject];
    if (self) {
        self.name = [responseObject objectForKey:@"name"];
    }
    return self;
}

@end
