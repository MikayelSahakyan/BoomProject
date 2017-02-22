//
//  FormModel.m
//  BoomProject
//
//  Created by User ACA on 2/20/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "FormModel.h"

@implementation FormModel

- (instancetype)initWithResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    if (self) {
        
        self.ID = [responseObject objectForKey:@"id"];
        self.name = [responseObject objectForKey:@"name"];
    }
    return self;
}

@end
