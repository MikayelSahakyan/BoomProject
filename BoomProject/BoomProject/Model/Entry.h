//
//  Entry.h
//  BoomProject
//
//  Created by User ACA on 2/28/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "ServiceObject.h"

@interface Entry : ServiceObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *rowID;

@end
