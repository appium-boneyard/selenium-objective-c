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
#import "HTTPUtils.h"
#import "SeleniumError.h"
#import "By.h"
#import "WebElement.h"

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
        [self getStatusAndReturnError:error];
        if ([*error code] != 0)
            return nil;
        
        // get session
		session = [self postSessionWithDesiredCapabilities:desiredCapabilities andRequiredCapabilities:requiredCapabilites error:error];
        if ([*error code] != 0)
            return nil;
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

-(NSURL*) url
{
	NSError *error;
	return [self urlAndReturnError:&error];
}

-(NSURL*) urlAndReturnError:(NSError**)error
{
    return [self getURLWithSession:[session sessionID] error:error];
}

-(void) setUrl:(NSURL*)url
{
	NSError *error;
	return [self setUrl:url error:&error];
}

-(void) setUrl:(NSURL*)url error:(NSError**)error
{
	[self postURL:url session:[session sessionID] error:error];
}

-(void) forward
{
	NSError *error;
	[self forwardAndReturnError:&error];
}

-(void) forwardAndReturnError:(NSError**)error
{
	[self postForwardWithSession:[session sessionID] error:error];
}

-(void) back
{
	NSError *error;
	[self backAndReturnError:&error];
}

-(void) backAndReturnError:(NSError**)error
{
	[self postBackWithSession:[session sessionID] error:error];
}

-(void) refresh
{
	NSError *error;
	[self refreshAndReturnError:&error];
}

-(void) refreshAndReturnError:(NSError**)error
{
	[self postRefreshWithSession:[session sessionID] error:error];
}

-(NSString*)pageSource
{
    NSError *error;
    return [self pageSourceAndReturnError:&error];
}

-(NSString*)pageSourceAndReturnError:(NSError **)error
{
	return [self getSourceWithSession:[session sessionID] error:error];
}

-(NSString*)title
{
    NSError *error;
	return [self titleAndReturnError:&error];
}

-(NSString*)titleAndReturnError:(NSError **)error
{
	return [self getTitleWithSession:[session sessionID] error:error];
}

-(WebElement*)findElement:(By*)by
{
	NSError *error;
	return [self findElement:by error:&error];
}

-(WebElement*)findElement:(By*)by error:(NSError**)error
{
	return [self postElement:by session:[session sessionID] error:error];
}

#pragma mark - JSON-Wire Protocol Implementation

// GET /status
-(RemoteWebDriverStatus*)getStatusAndReturnError:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/status", [self httpCommandExecutor]];
    NSDictionary *json = [HTTPUtils performGetRequestToUrl:urlString error:error];
	RemoteWebDriverStatus *webdriverStatus = [[RemoteWebDriverStatus alloc] initWithDictionary:json];
	return webdriverStatus;
}

// POST /session
-(RemoteWebDriverSession*)postSessionWithDesiredCapabilities:(Capabilities*)desiredCapabilities andRequiredCapabilities:(Capabilities*)requiredCapabilities error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session", [self httpCommandExecutor]];

	NSMutableDictionary *postDictionary = [NSMutableDictionary new];
	[postDictionary setValue:[desiredCapabilities dictionary] forKey:@"desiredCapabilities"];
	if (requiredCapabilities != nil)
	{
		[postDictionary setValue:[requiredCapabilities dictionary] forKey:@"requiredCapabilities"];
	}
	
	NSDictionary *json = [HTTPUtils performPostRequestToUrl:urlString postParams:postDictionary error:error];
	RemoteWebDriverSession *session = [[RemoteWebDriverSession alloc] initWithDictionary:json];
	return session;
}

// GET /sessions
-(NSArray*)getSessionsAndReturnError:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/sessions", [self httpCommandExecutor]];
    NSDictionary *json = [HTTPUtils performGetRequestToUrl:urlString error:error];

	NSMutableArray *sessions = [NSMutableArray new];
	NSArray *jsonItems = (NSArray*)[json objectForKey:@"value"];
	for(int i =0; i < [jsonItems count]; i++)
	{
		RemoteWebDriverSession *session = [[RemoteWebDriverSession alloc] initWithDictionary:[jsonItems objectAtIndex:i]];
		[sessions addObject:session];
	}
	return sessions;
}

// GET /session/:sessionId
-(RemoteWebDriverSession*)getSessionWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@", [self httpCommandExecutor], sessionId];
    NSDictionary *json = [HTTPUtils performGetRequestToUrl:urlString error:error];
	RemoteWebDriverSession *session = [[RemoteWebDriverSession alloc] initWithDictionary:json];
	return session;
}

// DELETE /session/:sessionId
-(void)deleteSessionWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@", [self httpCommandExecutor], sessionId];
	[HTTPUtils performDeleteRequestToUrl:urlString error:error];
}

// /session/:sessionId/timeouts
// /session/:sessionId/timeouts/async_script
// /session/:sessionId/timeouts/implicit_wait
// /session/:sessionId/window_handle
// /session/:sessionId/window_handles

// GET /session/:sessionId/url
-(NSURL*)getURLWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/url", [self httpCommandExecutor], sessionId];
    NSDictionary *json = [HTTPUtils performGetRequestToUrl:urlString error:error];
	NSString *url = [json objectForKey:@"value"];
	return [[NSURL alloc] initWithString:url];
}

// POST /session/:sessionId/url
-(void)postURL:(NSURL*)url session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/url", [self httpCommandExecutor], sessionId];
	NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[url absoluteString], @"url", nil];
	[HTTPUtils performPostRequestToUrl:urlString postParams:postDictionary error:error];
	
}

// POST /session/:sessionId/forward
-(void)postForwardWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/forward", [self httpCommandExecutor], sessionId];
	[HTTPUtils performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/back
-(void)postBackWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/back", [self httpCommandExecutor], sessionId];
	[HTTPUtils performPostRequestToUrl:urlString postParams:nil error:error];
}

// /session/:sessionId/refresh
-(void)postRefreshWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/refresh", [self httpCommandExecutor], sessionId];
	[HTTPUtils performPostRequestToUrl:urlString postParams:nil error:error];
}

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
-(NSString*)getSourceWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/source", [self httpCommandExecutor], sessionId];
    NSDictionary *json = [HTTPUtils performGetRequestToUrl:urlString error:error];
	NSString *source = [json objectForKey:@"value"];
	return source;
}

// GET /session/:sessionId/title
-(NSString*)getTitleWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/title", [self httpCommandExecutor], sessionId];
    NSDictionary *json = [HTTPUtils performGetRequestToUrl:urlString error:error];
	NSString *title = [json objectForKey:@"value"];
	return title;
}

// POST /session/:sessionId/element
-(WebElement*)postElement:(By*)locator session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element", [self httpCommandExecutor], sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[locator locationStrategy], @"using", [locator value], @"value", nil];
	NSDictionary *json = [HTTPUtils performPostRequestToUrl:urlString postParams:postParams error:error];
	NSString *elementId = [[json objectForKey:@"value"] objectForKey:@"ELEMENT"];
	WebElement *element = [[WebElement alloc] initWithOpaqueId:elementId];
	return element;
}

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
