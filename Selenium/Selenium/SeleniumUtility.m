//
//  SeleniumUtility.m
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SeleniumUtility.h"
#import "SeleniumError.h"

@implementation SeleniumUtility

+(NSDictionary*) performGetRequestToUrl:(NSString*)urlString error:(NSError**)error
{
	NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
											returningResponse:&response
														error:error];
    if ([*error code] != 0)
        return nil;
    
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData
														 options: NSJSONReadingMutableContainers
														   error: error];
    if ([*error code] != 0)
        return nil;
    
    *error = [SeleniumError errorWithResponseDict:json];
    if ([*error code] != 0)
        return nil;
    
	return json;
}

+(NSDictionary*) performPostRequestToUrl:(NSString*)urlString postParams:(NSDictionary*)postParams error:(NSError**)error
{
	NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	
	if (postParams == nil)
		postParams = [NSDictionary new];
	
	NSString *post =[self jsonStringFromDictionary:postParams];
    [request setValue:@"application/json, image/png" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	
	[request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLResponse *response = nil;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request
												 returningResponse:&response
															 error:error];
    if ([*error code] != 0)
        return nil;
	
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
	if ([httpResponse statusCode] != 200 && [httpResponse statusCode] != 303)
	{
		return nil;
	}

	
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
														 options: 0
														   error: error];
    if ([*error code] != 0)
        return nil;
    
    *error = [SeleniumError errorWithResponseDict:json];
    if ([*error code] != 0)
        return nil;
    return json;
}

+(NSDictionary*) performDeleteRequestToUrl:(NSString*)urlString error:(NSError**)error
{
	NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
   	[request setHTTPMethod:@"DELETE"];
	
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
											returningResponse:&response
														error:error];
    if ([*error code] != 0)
        return nil;
    
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData
														 options: NSJSONReadingMutableContainers
														   error: error];
    if ([*error code] != 0)
        return nil;
    
    *error = [SeleniumError errorWithResponseDict:json];
    if ([*error code] != 0)
        return nil;
    
	return json;
}

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
