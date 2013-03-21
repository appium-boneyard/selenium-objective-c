//
//  SEJsonWireClient.m
//  Selenium
//
//  Created by Dan Cuellar on 3/19/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SEJsonWireClient.h"
#import "SEUtility.h"
#import "SEStatus.h"
#import "NSData+Base64.h"

@interface SEJsonWireClient ()
	@property (readonly) NSString *httpCommandExecutor;
	@property NSString *serverAddress;
	@property NSInteger serverPort;
@end

@implementation SEJsonWireClient



-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(NSError**)error
{
    self = [super init];
    if (self) {
        [self setServerAddress:address];
        [self setServerPort:port];
		
        // get status
        [self getStatusAndReturnError:error];
        if ([*error code] != 0)
            return nil;
    }
    return self;
}

-(NSString*) httpCommandExecutor
{
    return [NSString stringWithFormat:@"http://%@:%d/wd/hub", self.serverAddress, (int)self.serverPort];
}

#pragma mark - JSON-Wire Protocol Implementation

// GET /status
-(SEStatus*) getStatusAndReturnError:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/status", self.httpCommandExecutor];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	SEStatus *webdriverStatus = [[SEStatus alloc] initWithDictionary:json];
	return webdriverStatus;
}

// POST /session
-(SESession*) postSessionWithDesiredCapabilities:(SECapabilities*)desiredCapabilities andRequiredCapabilities:(SECapabilities*)requiredCapabilities error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session", self.httpCommandExecutor];
	
	NSMutableDictionary *postDictionary = [NSMutableDictionary new];
	[postDictionary setValue:[desiredCapabilities dictionary] forKey:@"desiredCapabilities"];
	if (requiredCapabilities != nil)
	{
		[postDictionary setValue:[requiredCapabilities dictionary] forKey:@"requiredCapabilities"];
	}
	
	NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
	SESession *session = [[SESession alloc] initWithDictionary:json];
	return session;
}

// GET /sessions
-(NSArray*) getSessionsAndReturnError:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/sessions", self.httpCommandExecutor];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	
	NSMutableArray *sessions = [NSMutableArray new];
	NSArray *jsonItems = (NSArray*)[json objectForKey:@"value"];
	for(int i =0; i < [jsonItems count]; i++)
	{
		SESession *session = [[SESession alloc] initWithDictionary:[jsonItems objectAtIndex:i]];
		[sessions addObject:session];
	}
	return sessions;
}

// GET /session/:sessionId
-(SESession*) getSessionWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	SESession *session = [[SESession alloc] initWithDictionary:json];
	return session;
}

// DELETE /session/:sessionId
-(void) deleteSessionWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@", self.httpCommandExecutor, sessionId];
	[SEUtility performDeleteRequestToUrl:urlString error:error];
}

// /session/:sessionId/timeouts
-(void) postTimeout:(NSInteger)timeoutInMilliseconds forType:(SETimeoutType)type session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/timeouts", self.httpCommandExecutor, sessionId];
    NSString *timeoutType = [SEEnums stringForTimeoutType:type];
	NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys: timeoutType, @"type", [NSString stringWithFormat:@"%d", ((int)timeoutInMilliseconds)], @"ms", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// POST /session/:sessionId/timeouts/async_script
-(void) postAsyncScriptWaitTimeout:(NSInteger)timeoutInMilliseconds session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/timeouts/async_script", self.httpCommandExecutor, sessionId];
	NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", ((int)timeoutInMilliseconds)], @"ms", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// POST /session/:sessionId/timeouts/implicit_wait
-(void) postImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/timeouts/implicit_wait", self.httpCommandExecutor, sessionId];
	NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", ((int)timeoutInMilliseconds)], @"ms", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// GET /session/:sessionId/window_handle
-(NSString*) getWindowHandleWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window_handle", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *handle = [[NSString alloc] initWithString:(NSString*)[json objectForKey:@"value"]];
	return handle;
}

// GET /session/:sessionId/window_handles
-(NSArray*) getWindowHandlesWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window_handles", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	
	NSMutableArray *handles = [NSMutableArray new];
	NSArray *jsonItems = (NSArray*)[json objectForKey:@"value"];
	for(int i =0; i < [jsonItems count]; i++)
	{
		NSString *handle = [[NSString alloc] initWithString:(NSString*)[jsonItems objectAtIndex:i]];
		[handles addObject:handle];
	}
	return handles;
}

// GET /session/:sessionId/url
-(NSURL*) getURLWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/url", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *url = [json objectForKey:@"value"];
	return [[NSURL alloc] initWithString:url];
}

// POST /session/:sessionId/url
-(void) postURL:(NSURL*)url session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/url", self.httpCommandExecutor, sessionId];
	NSDictionary *postDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[url absoluteString], @"url", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// POST /session/:sessionId/forward
-(void) postForwardWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/forward", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/back
-(void) postBackWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/back", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/refresh
-(void) postRefreshWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/refresh", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/execute
-(NSDictionary*) postExecuteScript:(NSString*)script arguments:(NSArray*)arguments session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/execute", self.httpCommandExecutor, sessionId];
	NSMutableDictionary *postParams = [NSMutableDictionary new];
	[postParams setObject:script forKey:@"script"];
	if (arguments == nil || arguments.count < 1)
	{
		arguments = [NSArray new];
	}
	[postParams setObject:arguments forKey:@"args"];
	return [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/execute_async
-(NSDictionary*) postExecuteAsyncScript:(NSString*)script arguments:(NSArray*)arguments session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/execute_async", self.httpCommandExecutor, sessionId];
	NSMutableDictionary *postParams = [NSMutableDictionary new];
	[postParams setObject:script forKey:@"script"];
	if (arguments == nil || arguments.count < 1)
	{
		arguments = [NSArray new];
	}
	[postParams setObject:arguments forKey:@"args"];
	return [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/screenshot
-(NSImage*) getScreenshotWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/screenshot", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *pngString = [json objectForKey:@"value"];
	NSData *pngData = [NSData dataFromBase64String:pngString];
	NSImage *image = [[NSImage alloc] initWithData:pngData];
	return image;
}

// GET /session/:sessionId/ime/available_engines
-(NSArray*) getAvailableInputMethodEnginesWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/ime/available_engines", self.httpCommandExecutor, sessionId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSArray *jsonItems = (NSArray*)[json objectForKey:@"value"];
	NSMutableArray *engines = [NSMutableArray new];
	for (int i=0; i < [jsonItems count]; i++)
	{
		NSString *engine = [jsonItems objectAtIndex:i];
		[engines addObject:engine];
	}
	return engines;
}

// GET /session/:sessionId/ime/active_engine
-(NSString*) getActiveInputMethodEngineWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/ime/active_engine", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *activeEngine = [json objectForKey:@"value"];
	return activeEngine;
}

// GET /session/:sessionId/ime/activated
-(BOOL) getInputMethodEngineIsActivatedWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/ime/activated", self.httpCommandExecutor, sessionId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isActivated = [[json objectForKey:@"value"] boolValue];
	return isActivated;
}

// POST /session/:sessionId/ime/deactivate
-(void) postDeactivateInputMethodEngineWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/ime/deactivate", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/ime/activate
-(void) postActivateInputMethodEngine:(NSString*)engine session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/ime/activate", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: engine, @"engine", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/frame
-(void) postSetFrame:(id)name session:(NSString*)sessionId error:(NSError**)error
{
	if ([name isKindOfClass:[SEWebElement class]])
	{
		name = (SEWebElement*)[name elementJson];
	}
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/frame", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: name, @"name", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/window
-(void) postSetWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: windowHandle, @"name", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// DELETE /session/:sessionId/window
-(void) deleteWindowWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window", self.httpCommandExecutor, sessionId];
	[SEUtility performDeleteRequestToUrl:urlString error:error];
}

// POST /session/:sessionId/window/:windowHandle/size
-(void) postSetWindowSize:(NSSize)size window:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window/%@/size", self.httpCommandExecutor, sessionId, windowHandle];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:(size.width/1)], @"width", [NSNumber numberWithInt:(size.height/1)], @"height", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/window/:windowHandle/size
-(NSSize) getWindowSizeWithWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window/%@/size", self.httpCommandExecutor, sessionId, windowHandle];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSDictionary *valueJson = [json objectForKey:@"value"];
	float width = [[valueJson objectForKey:@"width"] floatValue];
	float height = [[valueJson objectForKey:@"height"] floatValue];
	NSSize size = NSMakeSize(width,height);
	return size;
}

// POST /session/:sessionId/window/:windowHandle/position
-(void) postSetWindowPosition:(NSPoint)position window:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window/%@/position", self.httpCommandExecutor, sessionId, windowHandle];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:(position.x / 1)], @"x", [NSNumber numberWithInt:(position.y/1)], @"y", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/window/:windowHandle/position
-(NSPoint) getWindowPositionWithWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window/%@/position", self.httpCommandExecutor, sessionId, windowHandle];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSDictionary *valueJson = [json objectForKey:@"value"];
	float x = [[valueJson objectForKey:@"x"] floatValue];
	float y = [[valueJson objectForKey:@"y"] floatValue];
	NSPoint position = NSMakePoint(x,y);
	return position;
}

// POST /session/:sessionId/window/:windowHandle/maximize
-(void) postMaximizeWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/window/%@/maximize", self.httpCommandExecutor, sessionId, windowHandle];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}


// GET /session/:sessionId/cookie
-(NSArray*) getCookiesWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/cookie", self.httpCommandExecutor, sessionId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSArray *jsonItems = (NSArray*)[json objectForKey:@"value"];
	NSMutableArray *cookies = [NSMutableArray new];
	for (int i=0; i < [jsonItems count]; i++)
	{
		NSMutableDictionary *cookieInfo = (NSMutableDictionary*)[jsonItems objectAtIndex:i];
		NSHTTPCookie *cookie = [SEUtility cookieWithJson:cookieInfo];
		[cookies addObject:cookie];
	}
	return cookies;
}

// POST /session/:sessionId/cookie
-(void) postCookie:(NSHTTPCookie*)cookie session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/cookie", self.httpCommandExecutor, sessionId];
	NSMutableDictionary *cookieJson = [NSMutableDictionary new];
	[cookieJson setObject:cookie.name forKey:@"name"];
	[cookieJson setObject:cookie.value forKey:@"value"];
	[cookieJson setObject:cookie.path forKey:@"path"];
	[cookieJson setObject:cookie.domain forKey:@"domain"];
	[cookieJson setObject:[NSNumber numberWithBool:cookie.isSecure] forKey:@"secure"];
	[cookieJson setObject:[NSNumber numberWithDouble:[cookie.expiresDate timeIntervalSince1970]] forKey:@"expiry"];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:cookieJson, @"cookie", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// DELETE /session/:sessionId/cookie
-(void) deleteCookiesWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/cookie", self.httpCommandExecutor, sessionId];
	[SEUtility performDeleteRequestToUrl:urlString error:error];
}

// DELETE /session/:sessionId/cookie/:name
-(void) deleteCookie:(NSString*)cookieName session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/cookie/%@", self.httpCommandExecutor, sessionId, cookieName];
	[SEUtility performDeleteRequestToUrl:urlString error:error];
}

// GET /session/:sessionId/source
-(NSString*) getSourceWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/source", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *source = [json objectForKey:@"value"];
	return source;
}

// GET /session/:sessionId/title
-(NSString*) getTitleWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/title", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *title = [json objectForKey:@"value"];
	return title;
}

// POST /session/:sessionId/element
-(SEWebElement*) postElement:(SEBy*)locator session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[locator locationStrategy], @"using", [locator value], @"value", nil];
	NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
	NSString *elementId = [[json objectForKey:@"value"] objectForKey:@"ELEMENT"];
	SEWebElement *element = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
	return element;
}

// POST /session/:sessionId/elements
-(NSArray*) postElements:(SEBy*)locator session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/elements", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[locator locationStrategy], @"using", [locator value], @"value", nil];
	NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
	NSArray *matches = (NSArray*)[json objectForKey:@"value"];
	NSMutableArray *elements = [NSMutableArray new];
	for (int i=0; i < [matches count]; i++)
	{
		NSString *elementId = [[matches objectAtIndex:i] objectForKey:@"ELEMENT"];
		SEWebElement *element = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
		[elements addObject:element];
	}
	return elements;
}

// POST /session/:sessionId/element/active
-(SEWebElement*) postActiveElementWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/active", self.httpCommandExecutor, sessionId];
	NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
	NSString *elementId = [[json objectForKey:@"value"] objectForKey:@"ELEMENT"];
	SEWebElement *element = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
	return element;
}

// /session/:sessionId/element/:id (FUTURE)
//
// IMPLEMENT ME
//
//

// POST /session/:sessionId/element/:id/element
-(SEWebElement*) postElementFromElement:(SEWebElement*)element by:(SEBy*)locator session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/elements", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[locator locationStrategy], @"using", [locator value], @"value", nil];
	NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
	NSString *elementId = [[json objectForKey:@"value"] objectForKey:@"ELEMENT"];
	SEWebElement *foundElement = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
	return foundElement;
}
// POST /session/:sessionId/element/:id/elements
-(NSArray*) postElementsFromElement:(SEWebElement*)element by:(SEBy*)locator session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/elements", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[locator locationStrategy], @"using", [locator value], @"value", nil];
	NSDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
	NSArray *matches = (NSArray*)[json objectForKey:@"value"];
	NSMutableArray *elements = [NSMutableArray new];
	for (int i=0; i < [matches count]; i++)
	{
		NSString *elementId = [[matches objectAtIndex:i] objectForKey:@"ELEMENT"];
		SEWebElement *element = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
		[elements addObject:element];
	}
	return elements;
}

// POST /session/:sessionId/element/:id/click
-(void) postClickElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/click", self.httpCommandExecutor, sessionId, element.opaqueId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/element/:id/submit
-(void) postSubmitElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/submit", self.httpCommandExecutor, sessionId, element.opaqueId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// GET /session/:sessionId/element/:id/text
-(NSString*) getElementText:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/text", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *text = [json objectForKey:@"value"];
	return text;
}

// POST /session/:sessionId/element/:id/value
-(void) postKeys:(unichar *)keys element:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/value", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSMutableArray *keyArray = [NSMutableArray new];
	for(int i=0; keys[i] != '\0'; i++)
	{
		[keyArray addObject:[NSString stringWithFormat:@"%C", keys[i]]];
	}
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: keyArray, @"value", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/keys
-(void) postKeys:(unichar *)keys session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/keys", self.httpCommandExecutor, sessionId];
	NSMutableArray *keyArray = [NSMutableArray new];
	for(int i=0; keys[i] != '\0'; i++)
	{
		[keyArray addObject:[NSString stringWithFormat:@"%C", keys[i]]];
	}
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: keyArray, @"value", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/element/:id/name
-(NSString*) getElementName:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/name", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *name = [json objectForKey:@"value"];
	return name;
}

// POST /session/:sessionId/element/:id/clear
-(void) postClearElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/clear", self.httpCommandExecutor, sessionId, element.opaqueId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// GET /session/:sessionId/element/:id/selected
-(BOOL) getElementIsSelected:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/selected", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isSelected = [[json objectForKey:@"value"] boolValue];
	return isSelected;
}

// GET /session/:sessionId/element/:id/enabled
-(BOOL) getElementIsEnabled:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/enabled", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isEnabled = [[json objectForKey:@"value"] boolValue];
	return isEnabled;
}

// GET /session/:sessionId/element/:id/attribute/:name
-(NSString*) getAttribute:(NSString*)attributeName element:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/attribute/%@", self.httpCommandExecutor, sessionId, element.opaqueId, attributeName];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *value = [json objectForKey:@"value"];
	return value;
}

// GET /session/:sessionId/element/:id/equals/:other
-(BOOL) getEqualityForElement:(SEWebElement*)element element:(SEWebElement*)otherElement session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/equals/%@", self.httpCommandExecutor, sessionId, element.opaqueId,[otherElement opaqueId]];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isEqual = [[json objectForKey:@"value"] boolValue];
	return isEqual;
}

// GET /session/:sessionId/element/:id/displayed
-(BOOL) getElementIsDisplayed:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/displayed", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isDisplayed = [[json objectForKey:@"value"] boolValue];
	return isDisplayed;
}

// GET /session/:sessionId/element/:id/location
-(NSPoint) getElementLocation:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/location", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSDictionary *valueJson = [json objectForKey:@"value"];
	float x = [[valueJson objectForKey:@"x"] floatValue];
	float y = [[valueJson objectForKey:@"y"] floatValue];
	NSPoint point = NSMakePoint(x,y);
	return point;
}

// GET /session/:sessionId/element/:id/location_in_view
-(NSPoint) getElementLocationInView:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/location_in_view", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSDictionary *valueJson = [json objectForKey:@"value"];
	float x = [[valueJson objectForKey:@"x"] floatValue];
	float y = [[valueJson objectForKey:@"y"] floatValue];
	NSPoint point = NSMakePoint(x,y);
	return point;
}

// GET /session/:sessionId/element/:id/size
-(NSSize) getElementSize:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/size", self.httpCommandExecutor, sessionId, element.opaqueId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSDictionary *valueJson = [json objectForKey:@"value"];
	float x = [[valueJson objectForKey:@"width"] floatValue];
	float y = [[valueJson objectForKey:@"height"] floatValue];
	NSSize size = NSMakeSize(x,y);
	return size;
}

// GET /session/:sessionId/element/:id/css/:propertyName
-(NSString*) getCSSProperty:(NSString*)propertyName element:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/element/%@/css/%@", self.httpCommandExecutor, sessionId, element.opaqueId, propertyName];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *value = [json objectForKey:@"value"];
	return value;
}

// GET /session/:sessionId/orientation
-(SEScreenOrientation) getOrientationWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/orientation", self.httpCommandExecutor, sessionId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	if ([*error code] != 0)
		return SELENIUM_SCREEN_ORIENTATION_UNKOWN;
	NSString *value = [json objectForKey:@"value"];
	return ([value isEqualToString:@"LANDSCAPE"] ? SELENIUM_SCREEN_ORIENTATION_LANDSCAPE : SELENIUM_SCREEN_ORIENTATION_PORTRAIT);
}

// POST /session/:sessionId/orientation
-(void) postOrientation:(SEScreenOrientation)orientation session:(NSString*)sessionId error:(NSError**)error
{
	if (orientation == SELENIUM_SCREEN_ORIENTATION_UNKOWN)
		return;
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/orientation", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:(orientation == SELENIUM_SCREEN_ORIENTATION_LANDSCAPE) ? @"LANDSCAPE" : @"PORTRAIT" , @"orientation", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/alert_text
-(NSString*) getAlertTextWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/alert_text", self.httpCommandExecutor, sessionId];
	NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	NSString *alertText = [json objectForKey:@"value"];
	return alertText;
}

// POST /session/:sessionId/alert_text
-(void) postAlertText:(NSString*)text session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/alert_text", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: text, @"text", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/accept_alert
-(void) postAcceptAlertWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/accept_alert", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/dismiss_alert
-(void) postDismissAlertWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/dismiss_alert", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/moveto
-(void) postMoveMouseToElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/move_to", self.httpCommandExecutor, sessionId];
	NSMutableDictionary *postParams = [NSMutableDictionary new];
	if (element != nil)
	{
		[postParams setObject:element.opaqueId forKey:@"element"];
	}
	[postParams setObject:[NSNumber numberWithInteger:xOffset] forKey:@"xoffset"];
	[postParams setObject:[NSNumber numberWithInteger:yOffset] forKey:@"yoffset"];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/click
-(void) postClickMouseButton:(SEMouseButton)button session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/click", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInteger:[SEEnums intForMouseButton:button]] , @"button", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/buttondown
-(void) postMouseButtonDown:(SEMouseButton)button session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/buttondown", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInteger:[SEEnums intForMouseButton:button]] , @"button", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/buttonup
-(void) postMouseButtonUp:(SEMouseButton)button session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/buttonup", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInteger:[SEEnums intForMouseButton:button]] , @"button", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/doubleclick
-(void) postDoubleClickWithSession:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/doubleclick", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/touch/click
-(void) postTapElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/click", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: element.opaqueId, @"element", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/down
-(void) postFingerDownAt:(NSPoint)point session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/down", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:(int)point.x] , @"x", [NSNumber numberWithInt:(int)point.y] , @"y", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/up
-(void) postFingerUpAt:(NSPoint)point session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/up", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:(int)point.x] , @"x", [NSNumber numberWithInt:(int)point.y] , @"y", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/move
-(void) postMoveFingerTo:(NSPoint)point session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/move", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:(int)point.x] , @"x", [NSNumber numberWithInt:(int)point.y] , @"y", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}



// POST /session/:sessionId/touch/scroll
-(void) postStartScrollingAtParticularLocation:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset session:(NSString*)sessionId error:(NSError**)error
{
	    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/scroll", self.httpCommandExecutor,sessionId];
	    NSMutableDictionary *postParams = [NSMutableDictionary new];
	    if(element != nil)
		{
			[postParams setObject:element.opaqueId forKey:@"element"];
		}
	    [postParams setObject: [NSNumber numberWithInteger:xOffset] forKey:@"xoffset"];
	    [postParams setObject: [NSNumber numberWithInteger:yOffset] forKey:@"yOffset"];
	    [SEUtility performPostRequestToUrl: urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/scroll
-(void) postScrollfromAnywhereOnTheScreenWithSession:(NSPoint)point session:(NSString*)sessionId error:(NSError**)error
{
	    NSString *urlString =[NSString stringWithFormat:@"%@/session/%@/touch/scroll", self.httpCommandExecutor, sessionId];
	    NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:(int)point.x], @"x" ,[NSNumber numberWithInt:(int)point.y],@"y",nil];
	  [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}


// POST /session/:sessionId/touch/doubleclick
-(void) postDoubleTapElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/doubleclick", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: element.opaqueId, @"element", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/longclick
-(void) postPressElement:(SEWebElement*)element session:(NSString*)sessionId error:(NSError**)error
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/touch/longclick", self.httpCommandExecutor, sessionId];
	NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys: element.opaqueId, @"element", nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/flick
// POST /session/:sessionId/touch/flick
// /session/:sessionId/location
// /session/:sessionId/local_storage
// /session/:sessionId/local_storage/key/:key
// /session/:sessionId/local_storage/size
// /session/:sessionId/session_storage
// /session/:sessionId/session_storage/key/:key
// /session/:sessionId/session_storage/size
// /session/:sessionId/log
// /session/:sessionId/log/types

// GET /session/:sessionId/application_cache/status
-(SEApplicationCacheStatus) getApplicationCacheStatusWithSession:(NSString*)sessionId error:(NSError**)error
{
    NSString *urlString = [NSString stringWithFormat:@"%@/session/%@/application_cache/status", self.httpCommandExecutor, sessionId];
    NSDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	 NSInteger appCacheStatus = [[json objectForKey:@"value"] integerValue];
    return [SEEnums applicationCacheStatusWithInt:appCacheStatus];

}

@end
