//
//  JSONWireClient.h
//  Selenium
//
//  Created by Dan Cuellar on 3/19/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteWebDriverSession.h"
#import "SeleniumCapabilities.h"
#import "WebElement.h"
#import "By.h"
#import "SeleniumEnums.h"

@class By;
@class SeleniumCapabilities;
@class RemoteWebDriverStatus;
@class RemoteWebDriverSession;
@class WebElement;

@interface JSONWireClient : NSObject

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(SeleniumCapabilities*)desiredCapabilities requiredCapabilities:(SeleniumCapabilities*)requiredCapabilites error:(NSError**)error;

#pragma mark - JSON-Wire Protocol Implementation

// GET /status
-(RemoteWebDriverStatus*) getStatusAndReturnError:(NSError**)error;

// POST /session
-(RemoteWebDriverSession*) postSessionWithDesiredCapabilities:(SeleniumCapabilities*)desiredCapabilities andRequiredCapabilities:(SeleniumCapabilities*)requiredCapabilities error:(NSError**)error;

// GET /sessions
-(NSArray*) getSessionsAndReturnError:(NSError**)error;

// GET /session/:sessionId
-(RemoteWebDriverSession*) getSessionWithSession:(NSString*)sessionId error:(NSError**)error;

// DELETE /session/:sessionId
-(void) deleteSessionWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/timeouts
-(void) postTimeout:(NSInteger)timeoutInMilliseconds forType:(SeleniumTimeoutType)type session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/timeouts/async_script
-(void) postAsyncScriptWaitTimeout:(NSInteger)timeoutInMilliseconds session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/timeouts/implicit_wait
-(void) postImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/window_handle
-(NSString*) getWindowHandleWithSession:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/window_handles
-(NSArray*) getWindowHandlesWithSession:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/url
-(NSURL*) getURLWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/url
-(void) postURL:(NSURL*)url session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/forward
-(void) postForwardWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/back
-(void) postBackWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/refresh
-(void) postRefreshWithSession:(NSString*)sessionId error:(NSError**)error;

// /session/:sessionId/execute
//
// IMPLEMENT ME
//
//

// /session/:sessionId/execute_async
//
// IMPLEMENT ME
//
//

// GET /session/:sessionId/screenshot
-(NSImage*) getScreenshotWithSession:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/ime/available_engines
-(NSArray*) getAvailableInputMethodEnginesWithSession:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/ime/active_engine
-(NSString*) getActiveInputMethodEngineWithSession:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/ime/activated
-(BOOL) getInputMethodEngineIsActivatedWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/ime/deactivate
-(void) postDeactivateInputMethodEngineWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/ime/activate
-(void) postActivateInputMethodEngine:(NSString*)engine session:(NSString*)sessionId error:(NSError**)error;

// /session/:sessionId/frame
//
// IMPLEMENT ME
//
//

// POST /session/:sessionId/window
-(void) postSetWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// DELETE /session/:sessionId/window
-(void) deleteWindowWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/window/:windowHandle/size
-(void) postSetWindowSize:(NSSize)size window:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/window/:windowHandle/size
-(NSSize) getWindowSizeWithWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/window/:windowHandle/position
-(void) postSetWindowPosition:(NSPoint)position window:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/window/:windowHandle/position
-(NSPoint) getWindowPositionWithWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/window/:windowHandle/maximize
-(void) postMaximizeWindow:(NSString*)windowHandle session:(NSString*)sessionId error:(NSError**)error;

// /session/:sessionId/cookie
//
// IMPLEMENT ME
//
//

// /session/:sessionId/cookie/:name
//
// IMPLEMENT ME
//
//

// GET /session/:sessionId/source
-(NSString*) getSourceWithSession:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/title
-(NSString*) getTitleWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element
-(WebElement*) postElement:(By*)locator session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/elements
-(NSArray*) postElements:(By*)locator session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/active
-(WebElement*) postActiveElementWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id
// FUTURE (NOT YET IMPLEMENTED)

// POST /session/:sessionId/element/:id/element
-(WebElement*) postElementFromElement:(WebElement*)element by:(By*)locator session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id/elements
-(NSArray*) postElementsFromElement:(WebElement*)element by:(By*)locator session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id/click
-(void) postClickElement:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id/submit
-(void) postSubmitElement:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/element/:id/text
-(NSString*) getElementText:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// /session/:sessionId/element/:id/value
// /session/:sessionId/keys

// GET /session/:sessionId/element/:id/name
-(NSString*) getElementName:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/element/:id/clear
-(void) postClearElement:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

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

// GET /session/:sessionId/element/:id/css/:propertyName
-(NSString*) getCSSProperty:(NSString*)propertyName element:(WebElement*)element session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/orientation
-(SeleniumScreenOrientation) getOrientationWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/orientation
-(void) postOrientation:(SeleniumScreenOrientation)orientation session:(NSString*)sessionId error:(NSError**)error;

// GET /session/:sessionId/alert_text
-(NSString*) getAlertTextWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/alert_text
-(void) postAlertText:(NSString*)text session:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/accept_alert
-(void) postAcceptAlertWithSession:(NSString*)sessionId error:(NSError**)error;

// POST /session/:sessionId/dismiss_alert
-(void) postDismissAlertWithSession:(NSString*)sessionId error:(NSError**)error;

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
