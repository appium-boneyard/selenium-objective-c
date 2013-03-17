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
#import "SeleniumError.h"

@implementation RemoteWebDriver

NSString *serverAddress;
NSInteger serverPort;
RemoteWebDriverSession *session;

-(NSString*)httpCommandExecutor
{
    return [NSString stringWithFormat:@"http://%@:%d/wd/hub", serverAddress, (int)serverPort];
}

#pragma mark - Public Methods

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(Capabilities*)desiredCapabilities requiredCapabilities:(Capabilities*)requiredCapabilites error:(NSError**)error
{
    self = [super init];
    if (self) {
        serverAddress = address;
        serverPort = port;

        // get status
        [self getStatusAndError:error];
        if ([*error code] != 0)
            return nil;
        
        // get session
		session = [self postSessionWithDesiredCapabilities:desiredCapabilities andRequiredCapabilities:requiredCapabilites error:error];
        if ([*error code] != 0)
            return nil;
        
		[self getSessionWithSession:[session sessionID] error:error];
    }
    return self;
}

-(void)quit
{
    NSError *error;
    [self quitAndError:&error];
}

-(void) quitAndError:(NSError **)error
{
	[self deleteSessionWithSession:[session sessionID] error:error];
}

-(NSString*)getPageSource
{
    NSError *error;
    return [self getPageSourceAndError:&error];
}

-(NSString*)getPageSourceAndError:(NSError **)error
{
	return [self getSourceWithSessions:[session sessionID] error:error];
}

#pragma mark - JSON-Wire Protocol Implementation

// GET /status
-(RemoteWebDriverStatus*)getStatusAndError:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/status", [self httpCommandExecutor]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest
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
    
	RemoteWebDriverStatus *webdriverStatus = [[RemoteWebDriverStatus alloc] initWithDictionary:json];
	return webdriverStatus;
}

// POST /session
-(RemoteWebDriverSession*)postSessionWithDesiredCapabilities:(Capabilities*)desiredCapabilities andRequiredCapabilities:(Capabilities*)requiredCapabilities error:(NSError**)error
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
    
	RemoteWebDriverSession *session = [[RemoteWebDriverSession alloc] initWithDictionary:json];
	return session;
}

// GET /sessions
-(NSArray*)getSessionsAndError:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/sessions", [self httpCommandExecutor]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest
											returningResponse:&response
														error:error];
    if ([*error code] != 0)
        return nil;
    
	NSArray *json = [NSJSONSerialization JSONObjectWithData:urlData
													options: NSJSONReadingMutableContainers
													  error: error];
    if ([*error code] != 0)
        return nil;
    
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
-(RemoteWebDriverSession*)getSessionWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@", [self httpCommandExecutor], sessionId];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest
											returningResponse:&response
														error:error];
    if ([*error code] != 0)
        return nil;
    
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlData
														 options:NSJSONReadingMutableContainers
														   error:error];
    if ([*error code] != 0)
        return nil;
	
    *error = [SeleniumError errorWithResponseDict:json];
    if ([*error code] != 0)
        return nil;
    
	RemoteWebDriverSession *session = [[RemoteWebDriverSession alloc] initWithDictionary:json];
	return session;
}

// DELETE /session/:sessionId
-(BOOL)deleteSessionWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@", [self httpCommandExecutor], sessionId];
	NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"DELETE"];
	
	NSURLResponse *response;
	[NSURLConnection sendSynchronousRequest:request
						  returningResponse:&response
									  error:error];
    if ([*error code] != 0)
        return NO;
	
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
	return ([httpResponse statusCode] == 200);
}

// /session/:sessionId/timeouts
// /session/:sessionId/timeouts/async_script
// /session/:sessionId/timeouts/implicit_wait
// /session/:sessionId/window_handle
// /session/:sessionId/window_handles
// /session/:sessionId/url
// /session/:sessionId/forward
// /session/:sessionId/back
// /session/:sessionId/refresh
// /session/:sessionId/execute
// /session/:sessionId/execute_async
// /session/:sessionId/screenshot
// /session/:sessionId/ime/available_engines
// /session/:sessionId/ime/active_engine
// /session/:sessionId/ime/activated
// /session/:sessionId/ime/deactivate
// /session/:sessionId/ime/activate
// /session/:sessionId/frame
// /session/:sessionId/window
// /session/:sessionId/window/:windowHandle/size
// /session/:sessionId/window/:windowHandle/position
// /session/:sessionId/window/:windowHandle/maximize
// /session/:sessionId/cookie
// /session/:sessionId/cookie/:name

// GET /session/:sessionId/source
-(NSString*)getSourceWithSessions:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/source", [self httpCommandExecutor], sessionId];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest
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
    
	NSString *source = [json objectForKey:@"value"];
	return source;
}

// /session/:sessionId/title
// /session/:sessionId/element
// /session/:sessionId/elements
// /session/:sessionId/element/active
// /session/:sessionId/element/:id
// /session/:sessionId/element/:id/element
// /session/:sessionId/element/:id/elements
// /session/:sessionId/element/:id/click
// /session/:sessionId/element/:id/submit
// /session/:sessionId/element/:id/text
// /session/:sessionId/element/:id/value
// /session/:sessionId/keys
// /session/:sessionId/element/:id/name
// /session/:sessionId/element/:id/clear
// /session/:sessionId/element/:id/selected
// /session/:sessionId/element/:id/enabled
// /session/:sessionId/element/:id/attribute/:name
// /session/:sessionId/element/:id/equals/:other
// /session/:sessionId/element/:id/displayed
// /session/:sessionId/element/:id/location
// /session/:sessionId/element/:id/location_in_view
// /session/:sessionId/element/:id/size
// /session/:sessionId/element/:id/css/:propertyName
// /session/:sessionId/orientation
// /session/:sessionId/alert_text
// /session/:sessionId/accept_alert
// /session/:sessionId/dismiss_alert
// /session/:sessionId/moveto
// /session/:sessionId/click
// /session/:sessionId/buttondown
// /session/:sessionId/buttonup
// /session/:sessionId/doubleclick
// /session/:sessionId/touch/click
// /session/:sessionId/touch/down
// /session/:sessionId/touch/up
// /session/:sessionId/touch/move
// /session/:sessionId/touch/scroll
// /session/:sessionId/touch/scroll
// /session/:sessionId/touch/doubleclick
// /session/:sessionId/touch/longclick
// /session/:sessionId/touch/flick
// /session/:sessionId/touch/flick
// /session/:sessionId/location
// /session/:sessionId/local_storage
// /session/:sessionId/local_storage/key/:key
// /session/:sessionId/local_storage/size
// /session/:sessionId/session_storage
// /session/:sessionId/session_storage/key/:key
// /session/:sessionId/session_storage/size
// /session/:sessionId/log
// /session/:sessionId/log/types
// /session/:sessionId/application_cache/status

@end
