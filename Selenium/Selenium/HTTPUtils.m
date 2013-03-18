//
//  HTTPUtils.m
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "HTTPUtils.h"
#import "JSONUtils.h"
#import "SeleniumError.h"

@implementation HTTPUtils

+(NSDictionary*) performGetRequestToUrl:(NSString*)urlString error:(NSError**)error
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
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
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	
	if (postParams == nil)
		postParams = [NSDictionary new];
	
	NSString *post =[JSONUtils jsonStringFromDictionary:postParams];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
	
	[request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLResponse *response;
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
														 options: NSJSONReadingMutableContainers
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
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

@end
