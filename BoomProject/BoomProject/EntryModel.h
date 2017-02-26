//
//  EntryModel.h
//  BoomProject
//
//  Created by User ACA on 2/24/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntryModel : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *rowID;

- (instancetype)initWithResponse:(NSDictionary *)responseObject;

@end
