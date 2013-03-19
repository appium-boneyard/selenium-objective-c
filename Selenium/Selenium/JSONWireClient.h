//
//  JSONWireClient.h
//  Selenium
//
//  Created by Dan Cuellar on 3/19/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteWebDriverSession.h"
#import "Capabilities.h"
#import "WebElement.h"
#import "By.h"

@class By;
@class Capabilities;
@class RemoteWebDriverStatus;
@class RemoteWebDriverSession;
@class WebElement;

@interface JSONWireClient : NSObject

@property (readonly) NSString *httpCommandExecutor;

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(Capabilities*)desiredCapabilities requiredCapabilities:(Capabilities*)requiredCapabilites error:(NSError**)error;

#pragma mark - JSON-Wire Protocol Implementation

// GET /status
-(RemoteWebDriverStatus*)getStatusAndReturnError:(NSError**)error;

// POST /session
-(RemoteWebDriverSession*)postSessionWithDesiredCapabilities:(Capabilities*)desiredCapabilities andRequiredCapabilities:(Capabilities*)requiredCapabilities error:(NSError**)error;

// GET /sessions
-(NSArray*)getSessionsAndReturnError:(NSError**)error;

// GET /session/:sessionId
-(RemoteWebDriverSession*)getSessionWithSession:(NSString*)sessionId error:(NSError**)error;

// DELETE /session/:sessionId
-(void)deleteSessionWithSession:(NSString*)sessionId error:(NSError**)error;

// /session/:sessionId/timeouts
// /session/:sessionId/timeouts/async_script
// /session/:sessionId/timeouts/implicit_wait
// /session/:sessionId/window_handle
// /session/:sessionId/window_handles

// GET /session/:sessionId/url
-(NSURL*)getURLWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/url
-(void)postURL:(NSURL*)url session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/forward
-(void)postForwardWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/back
-(void)postBackWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/refresh
-(void)postRefreshWithSession:(NSString*)sessionId error:(NSError**)error;

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
-(NSString*)getSourceWithSession:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/title
-(NSString*)getTitleWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element
-(WebElement*)postElement:(By*)locator session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/elements
-(NSArray*)postElements:(By*)locator session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/active
-(WebElement*)postActiveElementWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id
// FUTURE (NOT YET IMPLEMENTED)

// POST /session/:sessionId/element/:id/element
-(WebElement*)postElementFromElement:(WebElement*)element by:(By*)locator session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id/elements
-(NSArray*)postElementsFromElement:(WebElement*)element by:(By*)locator session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id/click
-(void)postClickElement:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id/submit
-(void)postSubmitElement:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/text
-(NSString*) getElementText:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// /session/:sessionId/element/:id/value
// /session/:sessionId/keys

// GET /session/:sessionId/element/:id/name
-(NSString*) getElementName:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id/clear
-(void)postClearElement:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/selected
-(BOOL) getElementIsSelected:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/enabled
-(BOOL) getElementIsEnabled:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/attribute/:name
-(NSString*) getAttribute:(NSString*)attributeName element:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/equals/:other
-(BOOL) getEqualityForElement:(WebElement*)element element:(WebElement*)otherElement session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/displayed
-(BOOL) getElementIsDisplayed:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/location
-(NSPoint) getElementLocation:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/location_in_view
-(NSPoint) getElementLocationInView:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/size
-(NSSize) getElementSize:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

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
