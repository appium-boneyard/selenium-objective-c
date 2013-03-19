//
//  JSONWireClient.m
//  Selenium
//
//  Created by Dan Cuellar on 3/19/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "JSONWireClient.h"
#import "HTTPUtils.h"
#import "RemoteWebDriverStatus.h"

@implementation JSONWireClient

NSString *serverAddress;
NSInteger serverPort;

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
    }
    return self;
}

-(NSString*)httpCommandExecutor
{
    return [NSString stringWithFormat:@"http://%@:%d/wd/hub", serverAddress, (int)serverPort];
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
	WebElement *element = [[WebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
	return element;
}

// POST /session/:sessionId/elements
-(NSArray*)postElements:(By*)locator session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/elements", [self httpCommandExecutor], sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[locator locationStrategy], @"using", [locator value], @"value", nil];
	NSDictionary *json = [HTTPUtils performPostRequestToUrl:urlString postParams:postParams error:error];
	NSArray *matches = (NSArray*)[json objectForKey:@"value"];
	NSMutableArray *elements = [NSMutableArray new];
	for (int i=0; i < [matches count]; i++)
	{
		NSString *elementId = [[matches objectAtIndex:i] objectForKey:@"ELEMENT"];
		WebElement *element = [[WebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
		[elements addObject:element];
	}
	return elements;
}

// POST /session/:sessionId/element/active
-(WebElement*)postActiveElementWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/active", [self httpCommandExecutor], sessionId];
	NSDictionary *json = [HTTPUtils performPostRequestToUrl:urlString postParams:nil error:error];
	NSString *elementId = [[json objectForKey:@"value"] objectForKey:@"ELEMENT"];
	WebElement *element = [[WebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
	return element;
}

// /session/:sessionId/element/:id (FUTURE)

// POST /session/:sessionId/element/:id/element
-(WebElement*)postElementFromElement:(WebElement*)element by:(By*)locator session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/elements", [self httpCommandExecutor], sessionId, [element opaqueId]];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[locator locationStrategy], @"using", [locator value], @"value", nil];
	NSDictionary *json = [HTTPUtils performPostRequestToUrl:urlString postParams:postParams error:error];
	NSString *elementId = [[json objectForKey:@"value"] objectForKey:@"ELEMENT"];
	WebElement *foundElement = [[WebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
	return foundElement;
}
// POST /session/:sessionId/element/:id/elements
-(NSArray*)postElementsFromElement:(WebElement*)element by:(By*)locator session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/elements", [self httpCommandExecutor], sessionId, [element opaqueId]];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[locator locationStrategy], @"using", [locator value], @"value", nil];
	NSDictionary *json = [HTTPUtils performPostRequestToUrl:urlString postParams:postParams error:error];
	NSArray *matches = (NSArray*)[json objectForKey:@"value"];
	NSMutableArray *elements = [NSMutableArray new];
	for (int i=0; i < [matches count]; i++)
	{
		NSString *elementId = [[matches objectAtIndex:i] objectForKey:@"ELEMENT"];
		WebElement *element = [[WebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
		[elements addObject:element];
	}
	return elements;
}

// POST /session/:sessionId/element/:id/click
-(void)postClickElement:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/click", [self httpCommandExecutor], sessionId, [element opaqueId]];
	[HTTPUtils performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/element/:id/submit
-(void)postSubmitElement:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/submit", [self httpCommandExecutor], sessionId, [element opaqueId]];
	[HTTPUtils performPostRequestToUrl:urlString postParams:nil error:error];
}

// GET /session/:sessionId/element/:id/text
-(NSString*) getElementText:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/text", [self httpCommandExecutor], sessionId, [element opaqueId]];
	NSDictionary *json = [HTTPUtils performGetRequestToUrl:urlString error:error];
	NSString *text = [json objectForKey:@"value"];
	return text;
}

// /session/:sessionId/element/:id/value
// /session/:sessionId/keys

// GET /session/:sessionId/element/:id/name
-(NSString*) getElementName:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/name", [self httpCommandExecutor], sessionId, [element opaqueId]];
	NSDictionary *json = [HTTPUtils performGetRequestToUrl:urlString error:error];
	NSString *name = [json objectForKey:@"value"];
	return name;
}

// POST /session/:sessionId/element/:id/clear
-(void)postClearElement:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/clear", [self httpCommandExecutor], sessionId, [element opaqueId]];
	[HTTPUtils performPostRequestToUrl:urlString postParams:nil error:error];
}

// GET /session/:sessionId/element/:id/selected
-(BOOL) getElementIsSelected:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/selected", [self httpCommandExecutor], sessionId, [element opaqueId]];
	NSDictionary *json = [HTTPUtils performGetRequestToUrl:urlString error:error];
	BOOL isSelected = [[json objectForKey:@"value"] boolValue];
	return isSelected;
}

// GET /session/:sessionId/element/:id/enabled
-(BOOL) getElementIsEnabled:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/enabled", [self httpCommandExecutor], sessionId, [element opaqueId]];
	NSDictionary *json = [HTTPUtils performGetRequestToUrl:urlString error:error];
	BOOL isEnabled = [[json objectForKey:@"value"] boolValue];
	return isEnabled;
}

// GET /session/:sessionId/element/:id/attribute/:name
-(NSString*) getAttribute:(NSString*)attributeName element:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/attribute/%@", [self httpCommandExecutor], sessionId, [element opaqueId], attributeName];
	NSDictionary *json = [HTTPUtils performGetRequestToUrl:urlString error:error];
	NSString *value = [json objectForKey:@"value"];
	return value;
}

// GET /session/:sessionId/element/:id/equals/:other
-(BOOL) getEqualityForElement:(WebElement*)element element:(WebElement*)otherElement session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/equals/%@", [self httpCommandExecutor], sessionId, [element opaqueId],[otherElement opaqueId]];
	NSDictionary *json = [HTTPUtils performGetRequestToUrl:urlString error:error];
	BOOL isEqual = [[json objectForKey:@"value"] boolValue];
	return isEqual;
}

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
