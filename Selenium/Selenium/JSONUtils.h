//
//  JSONUtils.h
//  Selenium
//
//  Created by Dan Cuellar on 3/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONUtils : NSObject

+(NSData*) jsonDataFromDictionary:(NSDictionary*)dictionary;
+(NSString*) jsonStringFromDictionary:(NSDictionary*)dictionary;

@end
