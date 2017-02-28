//
//  ServiceObject.h
//  BoomProject
//
//  Created by User ACA on 2/28/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceObject : NSObject

@property (strong, nonatomic) NSString *ID;

- (instancetype)initWithResponse:(NSDictionary *)responseObject;

@end
