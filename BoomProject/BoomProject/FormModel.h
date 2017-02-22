//
//  FormModel.h
//  BoomProject
//
//  Created by User ACA on 2/20/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormModel : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;

- (instancetype)initWithResponse:(NSDictionary *)responseObject;

@end
