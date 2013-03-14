//
//  Selenium.m
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "RemoteWebDriver.h"
#import "RemoteWebDriverStatus.h"
#import "JSONUtils.h"

@implementation RemoteWebDriver

NSString *serverAddress;
NSInteger serverPort;
NSString *sessionID;

-(NSString*)httpCommandExecutor
{
    return [NSString stringWithFormat:@"http://%@:%d/wd/hub", serverAddress, (int)serverPort];
}

- (id)initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(Capabilities*)desiredCapabilities requiredCapabilities:(Capabilities*)requiredCapabilites
{
    self = [super init];
    if (self) {
        serverAddress = address;
        serverPort = port;
        [self getStatus];
		sessionID = [self postSesssionWithDesiredCapabilities:desiredCapabilities andRequiredCapabilities:requiredCapabilites];
    }
    return self;
}

-(RemoteWebDriverStatus*)getStatus
{
	NSString *urlString = [NSString stringWithFormat:@"%@/status", [self httpCommandExecutor]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSURLResponse *response;
    NSError *error;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    return [[RemoteWebDriverStatus alloc] initWithJSON:urlData];
}

-(NSString*)postSesssionWithDesiredCapabilities:(Capabilities*)desiredCapabilities andRequiredCapabilities:(Capabilities*)requiredCapabilities
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session", [self httpCommandExecutor]];
	NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	NSMutableDictionary *postDictionary = [NSMutableDictionary new];
	[postDictionary setValue:[desiredCapabilities dictionary] forKey:@"desiredCapabilities"];
	if (requiredCapabilities != nil)
	{
		[postDictionary setValue:[requiredCapabilities dictionary] forKey:@"requiredCapabilities"];
	}
	NSString *post =[JSONUtils jsonStringFromDictionary:postDictionary];
	
	[request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLResponse *response;
	NSError *err;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request
												 returningResponse:&response
															 error:&err];
	
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
	if ([httpResponse statusCode] != 200 && [httpResponse statusCode] != 303)
	{
		return nil;
	}
	
	NSError *e = nil;
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
														 options: NSJSONReadingMutableContainers
														   error: &e];
	return [json objectForKey:@"sessionId"];
}

@end
