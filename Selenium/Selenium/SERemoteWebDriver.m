//
//  SERemoteWebDriver.m
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SERemoteWebDriver.h"

@interface SERemoteWebDriver ()
	@property SEJsonWireClient *jsonWireClient;
@end

@implementation SERemoteWebDriver

#pragma mark - Public Methods

-(id) init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class SERemoteWebDriver"
                                 userInfo:nil];
    return nil;
}

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(NSError**)error
{
    self = [super init];
    if (self) {
		[self setErrors:[NSMutableArray new]];
        [self setJsonWireClient:[[SEJsonWireClient alloc] initWithServerAddress:address port:port desiredCapabilities:desiredCapabilities requiredCapabilities:requiredCapabilites error:error]];
		[self addError:*error];
		
		// get session
		[self setSession:[self.jsonWireClient postSessionWithDesiredCapabilities:desiredCapabilities andRequiredCapabilities:requiredCapabilites error:error]];
		[self addError:*error];
        if ([*error code] != 0)
            return nil;
    }
    return self;
}

-(void)addError:(NSError*)error
{
	if (error == nil || error.code == 0)
		return;
	NSLog(@"Selenium Error: %ld - %@", error.code, error.description);
	[self setLastError:error];
	[[self errors] addObject:error];
}

-(void)quit
{
    NSError *error;
	[self.jsonWireClient deleteSessionWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(SETimeoutType)type
{
    NSError *error;
    [self.jsonWireClient postTimeout:timeoutInMilliseconds forType:type session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds
{
	NSError *error;
	[self.jsonWireClient postAsyncScriptWaitTimeout:timeoutInMilliseconds session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds
{
	NSError *error;
	[self.jsonWireClient postImplicitWaitTimeout:timeoutInMilliseconds session:self.session.sessionId error:&error];
	[self addError:error];
}

-(NSString*) window
{
	NSError *error;
	NSString* window = [self.jsonWireClient getWindowHandleWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return window;
}

-(NSArray*) allWindows
{
	NSError *error;
	NSArray * windows = [self.jsonWireClient getWindowHandlesWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return windows;
}

-(NSURL*) url
{
	NSError *error;
    NSURL *url = [self.jsonWireClient getURLWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return url;
}

-(void) setUrl:(NSURL*)url
{
	NSError *error;
	[self.jsonWireClient postURL:url session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) forward
{
	NSError *error;
	[self.jsonWireClient postForwardWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) back
{
	NSError *error;
	[self.jsonWireClient postBackWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) refresh
{
	NSError *error;
	[self.jsonWireClient postRefreshWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(NSDictionary*) executeScript:(NSString*)script
{
	return [self executeScript:script arguments:nil];
}

-(NSDictionary*) executeScript:(NSString*)script arguments:(NSArray*)arguments
{
	NSError *error;
	NSDictionary *output = [self.jsonWireClient postExecuteScript:script arguments:arguments session:self.session.sessionId error:&error];
	[self addError:error];
	return output;
}

-(NSDictionary*) executeAnsynchronousScript:(NSString*)script
{
	return [self executeAnsynchronousScript:script arguments:nil];
}

-(NSDictionary*) executeAnsynchronousScript:(NSString*)script arguments:(NSArray*)arguments
{
	NSError *error;
	NSDictionary *output = [self.jsonWireClient postExecuteAsyncScript:script arguments:arguments session:self.session.sessionId error:&error];
	[self addError:error];
	return output;
}

-(NSImage*) screenshot
{
	NSError *error;
	NSImage *image = [self.jsonWireClient getScreenshotWithSession:self.session.sessionId error:&error];
	return image;
}

-(NSArray*) availableInputMethodEngines
{
	NSError *error;
	NSArray *engines = [self.jsonWireClient getAvailableInputMethodEnginesWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return engines;
}

-(NSString*) activeInputMethodEngine
{
    NSError *error;
	NSString *engine = [self.jsonWireClient getActiveInputMethodEngineWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return engine;
}

-(BOOL) inputMethodEngineIsActive
{
    NSError *error;
	BOOL isActive = [self.jsonWireClient getInputMethodEngineIsActivatedWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return isActive;
}

-(void) deactivateInputMethodEngine
{
    NSError *error;
	[self.jsonWireClient postDeactivateInputMethodEngineWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) activateInputMethodEngine:(NSString*)engine
{
    NSError *error;
	[self.jsonWireClient postActivateInputMethodEngine:engine session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) setFrame:(id)name
{
	NSError* error;
	[self.jsonWireClient postSetFrame:name session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) setWindow:(NSString*)windowHandle
{
	NSError* error;
	[self.jsonWireClient postSetWindow:windowHandle session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) closeWindow:(NSString*)windowHandle
{
	NSError* error;
	[self.jsonWireClient deleteWindowWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) setWindowSize:(NSSize)size window:(NSString*)windowHandle
{
	NSError *error;
	[self.jsonWireClient postSetWindowSize:size window:windowHandle session:self.session.sessionId error:&error];
	[self addError:error];
}

-(NSSize) windowSizeForWindow:(NSString*)windowHandle
{
	NSError *error;
	NSSize size = [self.jsonWireClient getWindowSizeWithWindow:windowHandle session:self.session.sessionId error:&error];
	[self addError:error];
	return size;
}

-(void) setWindowPosition:(NSPoint)position window:(NSString*)windowHandle
{
	NSError *error;
	[self.jsonWireClient postSetWindowPosition:position window:windowHandle session:self.session.sessionId error:&error];
	[self addError:error];
}

-(NSPoint) windowPositionForWindow:(NSString*)windowHandle
{
	NSError *error;
	NSPoint position = [self.jsonWireClient getWindowPositionWithWindow:windowHandle session:self.session.sessionId error:&error];
	[self addError:error];
	return position;
}

-(void) maximizeWindow:(NSString*)windowHandle
{
	NSError *error;
	[self.jsonWireClient postMaximizeWindow:windowHandle session:self.session.sessionId error:&error];
	[self addError:error];
}

-(NSArray*) cookies
{
	NSError *error;
	NSArray *cookies = [self.jsonWireClient getCookiesWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return cookies;
}

-(void) setCookie:(NSHTTPCookie*)cookie
{
	NSError *error;
	[self.jsonWireClient postCookie:cookie session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) deleteCookies
{
	NSError *error;
	[self.jsonWireClient deleteCookiesWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) deleteCookie:(NSString*)cookieName
{
	NSError *error;
	[self.jsonWireClient deleteCookie:cookieName session:self.session.sessionId error:&error];
	[self addError:error];
}

-(NSString*) pageSource
{
    NSError *error;
    NSString *source = [self.jsonWireClient getSourceWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return source;
}

-(NSString*) title
{
    NSError *error;
	NSString *title = [self.jsonWireClient getTitleWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return title;
}

-(SEWebElement*) findElementBy:(SEBy*)by
{
	NSError *error;
	SEWebElement *element = [self.jsonWireClient postElement:by session:self.session.sessionId error:&error];
	[self addError:error];
	return element;
}

-(NSArray*) findElementsBy:(SEBy*)by
{
	NSError *error;
	NSArray *elements = [self.jsonWireClient postElements:by session:self.session.sessionId error:&error];
	[self addError:error];
	return elements;
}

-(SEWebElement*) activeElement
{
	NSError *error;
	SEWebElement *element = [self.jsonWireClient postActiveElementWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return element;
}

-(void) sendKeys:(NSString*)keyString
{
	NSError *error;
	unichar keys[keyString.length+1];
	for(int i=0; i < keyString.length; i++)
		keys[i] = [keyString characterAtIndex:i];
	keys[keyString.length] = '\0';
	[self.jsonWireClient postKeys:keys session:self.session.sessionId error:&error];
	[self addError:error];
}

-(SEScreenOrientation) orientation
{
	NSError *error;
	SEScreenOrientation orientation = [self.jsonWireClient getOrientationWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return orientation;
}

-(void) setOrientation:(SEScreenOrientation)orientation
{
	NSError* error;
	[self.jsonWireClient postOrientation:orientation session:self.session.sessionId error:&error];
	[self addError:error];
}

-(NSString*)alertText
{
    NSError *error;
	NSString *alertText = [self.jsonWireClient getAlertTextWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return alertText;
}

-(void) setAlertText:(NSString*)text
{
	NSError* error;
	[self.jsonWireClient postAlertText:text session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) acceptAlert
{
	NSError *error;
	[self.jsonWireClient postAcceptAlertWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) dismissAlert
{
	NSError *error;
	[self.jsonWireClient postDismissAlertWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) moveMouseWithXOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset
{
	[self moveMouseToElement:nil xOffset:xOffset yOffset:yOffset];
}

-(void) moveMouseToElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset
{
	NSError *error;
	[self.jsonWireClient postMoveMouseToElement:element xOffset:xOffset yOffset:yOffset session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) click
{
	[self clickMouseButton:SELENIUM_MOUSE_LEFT_BUTTON];
}

-(void) clickMouseButton:(SEMouseButton)button
{
	NSError *error;
	[self.jsonWireClient postClickMouseButton:button session:self.session.sessionId error:&error];

	[self addError:error];
}

-(void) mouseButtonDown:(SEMouseButton)button
{
	NSError *error;
	[self.jsonWireClient postMouseButtonDown:button session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) mouseButtonUp:(SEMouseButton)button
{
	NSError *error;
	[self.jsonWireClient postMouseButtonUp:button session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) doubleclick
{
	NSError *error;
	[self.jsonWireClient postDoubleClickWithSession:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) tapElement:(SEWebElement*)element
{
	NSError *error;
	[self.jsonWireClient postTapElement:element session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) fingerDownAt:(NSPoint)point
{
	NSError *error;
	[self.jsonWireClient postFingerDownAt:point session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) fingerUpAt:(NSPoint)point
{
	NSError *error;
	[self.jsonWireClient postFingerUpAt:point session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) moveFingerTo:(NSPoint)point
{
	NSError *error;
	[self.jsonWireClient postMoveFingerTo:point session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) doubletapElement:(SEWebElement*)element
{
	NSError *error;
	[self.jsonWireClient postDoubleTapElement:element session:self.session.sessionId error:&error];
	[self addError:error];
}

-(void) pressElement:(SEWebElement*)element
{
	NSError *error;
	[self.jsonWireClient postPressElement:element session:self.session.sessionId error:&error];
	[self addError:error];
}

-(SEApplicationCacheStatus) applicationCacheStatus
{
    NSError* error;
    SEApplicationCacheStatus status = [self.jsonWireClient getApplicationCacheStatusWithSession:self.session.sessionId error:&error];
	[self addError:error];
	return status;
}

@end
