//
//  JSONUtils.m
//  Selenium
//
//  Created by Dan Cuellar on 3/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "JSONUtils.h"

@implementation JSONUtils

+(NSData*) jsonDataFromDictionary:(NSDictionary*)dictionary
{
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
													   options:0/*NSJSONWritingPrettyPrinted*/
														 error:&error];
	return jsonData;
}

+(NSString*) jsonStringFromDictionary:(NSDictionary*)dictionary
{
	NSData *jsonData = [self jsonDataFromDictionary:dictionary];
	NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	return jsonString;
}
@end
