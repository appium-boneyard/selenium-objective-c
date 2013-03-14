//
//  Selenium.m
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "RemoteWebDriver.h"
#import "RemoteWebDriverStatus.h"
#import "RemoteWebDriverSession.h"
#import "JSONUtils.h"

@implementation RemoteWebDriver

NSString *serverAddress;
NSInteger serverPort;
RemoteWebDriverSession *session;

-(NSString*)httpCommandExecutor
{
    return [NSString stringWithFormat:@"http://%@:%d/wd/hub", serverAddress, (int)serverPort];
}

#pragma mark - Public Methods

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(Capabilities*)desiredCapabilities requiredCapabilities:(Capabilities*)requiredCapabilites
{
    self = [super init];
    if (self) {
        serverAddress = address;
        serverPort = port;
        [self getStatus];
		session = [self postSessionWithDesiredCapabilities:desiredCapabilities andRequiredCapabilities:requiredCapabilites];
		[self getSessionWithSession:[session sessionID]];
    }
    return self;
}

-(void) quit
{
	[self deleteSessionWithSession:[session sessionID]];
}

-(NSString*)getPageSource
{
	return [self getSourceWithSessions:[session sessionID]];
}

#pragma mark - JSON-Wire Protocol Implementation

// GET /status
-(RemoteWebDriverStatus*)getStatus
{
	NSString *urlString = [NSString stringWithFormat:@"%@/status", [self httpCommandExecutor]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSURLResponse *response;
    NSError *error;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
	NSError *e;
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData
														 options: NSJSONReadingMutableContainers
														   error: &e];
	
	RemoteWebDriverStatus *webdriverStatus = [[RemoteWebDriverStatus alloc] initWithDictionary:json];
	return webdriverStatus;
}

// POST /session
-(RemoteWebDriverSession*)postSessionWithDesiredCapabilities:(Capabilities*)desiredCapabilities andRequiredCapabilities:(Capabilities*)requiredCapabilities
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
	RemoteWebDriverSession *session = [[RemoteWebDriverSession alloc] initWithDictionary:json];
	return session;
}

// GET /sessions
-(NSArray*)getSessions
{
	NSString *urlString = [NSString stringWithFormat:@"%@/sessions", [self httpCommandExecutor]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSURLResponse *response;
    NSError *error;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest
											returningResponse:&response
														error:&error];
	NSError *e;
	NSArray *json = [NSJSONSerialization JSONObjectWithData:urlData
														 options: NSJSONReadingMutableContainers
														   error: &e];
	NSMutableArray *sessions = [NSMutableArray new];
	NSEnumerator *enumerator = [json objectEnumerator];
	id object;
	while (object = [enumerator nextObject]) {
	RemoteWebDriverSession *session = [[RemoteWebDriverSession alloc] initWithDictionary:object];
		[sessions addObject:session];
	}
	return sessions;
}

// GET /session/:sessionId
-(RemoteWebDriverSession*)getSessionWithSession:(NSString*)sessionId
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@", [self httpCommandExecutor], sessionId];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSURLResponse *response;
    NSError *error;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest
											returningResponse:&response
														error:&error];
	NSError *e;
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData
													options: NSJSONReadingMutableContainers
													  error: &e];
	
	RemoteWebDriverSession *session = [[RemoteWebDriverSession alloc] initWithDictionary:json];
	return session;
}

// DELETE /session/:sessionId
-(BOOL)deleteSessionWithSession:(NSString*)sessionId
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@", [self httpCommandExecutor], sessionId];
	NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"DELETE"];
	
	NSURLResponse *response;
	NSError *err;
	[NSURLConnection sendSynchronousRequest:request
						  returningResponse:&response
									  error:&err];
	
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
	return ([httpResponse statusCode] == 200);
}

// GET /session/:sessionId/source
-(NSString*)getSourceWithSessions:(NSString*)sessionId
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/source", [self httpCommandExecutor], sessionId];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSURLResponse *response;
    NSError *error;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest
											returningResponse:&response
														error:&error];
	NSError *e;
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData
													options: NSJSONReadingMutableContainers
													  error: &e];
	NSString *source = [json objectForKey:@"value"];
	return source;
}

@end
