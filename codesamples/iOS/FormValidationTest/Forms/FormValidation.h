//
//  FormValidation.h
//  Code Samples
//
//  Created by Tim Hingston on 3/24/14.
//  Copyright (c) 2014 Tim Hingston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidationRule.h"

#define kFormValidationRegexEmail @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
#define kFormValidationRegexUsername @"[A-Z0-9a-z_]*"


@interface FormValidation : NSObject

+ (BOOL)isValidEmail:(NSString*)email;
+ (BOOL)isValidUsername:(NSString*)username;
+ (ValidationError)testCharacterLimitForField:(UITextField*)textField withRange:(MinMaxRange)range;
+ (NSArray*)validateRules:(NSArray*)validationRules forTestObject:(id)testObject stopOnError:(BOOL)stopOnError;

@end
