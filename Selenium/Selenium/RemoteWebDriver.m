//
//  Selenium.m
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "RemoteWebDriver.h"

@interface RemoteWebDriver ()
	@property JSONWireClient *jsonWireClient;
@end


@implementation RemoteWebDriver

#pragma mark - Public Methods

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(Capabilities*)desiredCapabilities requiredCapabilities:(Capabilities*)requiredCapabilites error:(NSError**)error
{
    self = [super init];
    if (self) {
        [self setJsonWireClient:[[JSONWireClient alloc] initWithServerAddress:address port:port desiredCapabilities:desiredCapabilities requiredCapabilities:requiredCapabilites error:error]];
		
		// get session
		[self setSession:[self.jsonWireClient postSessionWithDesiredCapabilities:desiredCapabilities andRequiredCapabilities:requiredCapabilites error:error]];
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
	[self.jsonWireClient deleteSessionWithSession:self.session.sessionId error:error];
}

-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(SeleniumTimeoutType)type
{
    NSError *error;
    [self setTimeout:timeoutInMilliseconds forType:type error:&error];
}

-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(SeleniumTimeoutType)type error:(NSError**)error
{
    [self.jsonWireClient postTimeout:timeoutInMilliseconds forType:type session:self.session.sessionId error:error];
}

-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds
{
	NSError *error;
	[self setAsyncScriptTimeout:timeoutInMilliseconds error:&error];
}

-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds error:(NSError**)error
{
	[self.jsonWireClient postAsyncScriptWaitTimeout:timeoutInMilliseconds session:self.session.sessionId error:error];
}

-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds
{
	NSError *error;
	[self setImplicitWaitTimeout:timeoutInMilliseconds error:&error];
}

-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds error:(NSError**)error
{
	[self.jsonWireClient postImplicitWaitTimeout:timeoutInMilliseconds session:self.session.sessionId error:error];
}

-(NSString*) windowHandle
{
	NSError *error;
	return [self windowHandleAndReturnError:&error];
}

-(NSString*) windowHandleAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getWindowHandleWithSession:self.session.sessionId error:error];
}

-(NSArray*) windowHandles
{
	NSError *error;
	return [self windowHandlesAndReturnError:&error];
}

-(NSArray*) windowHandlesAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getWindowHandlesWithSession:self.session.sessionId error:error];
}

-(NSURL*) url
{
	NSError *error;
	return [self urlAndReturnError:&error];
}

-(NSURL*) urlAndReturnError:(NSError**)error
{
    return [self.jsonWireClient getURLWithSession:self.session.sessionId error:error];
}

-(void) setUrl:(NSURL*)url
{
	NSError *error;
	return [self setUrl:url error:&error];
}

-(void) setUrl:(NSURL*)url error:(NSError**)error
{
	[self.jsonWireClient postURL:url session:self.session.sessionId error:error];
}

-(void) forward
{
	NSError *error;
	[self forwardAndReturnError:&error];
}

-(void) forwardAndReturnError:(NSError**)error
{
	[self.jsonWireClient postForwardWithSession:self.session.sessionId error:error];
}

-(void) back
{
	NSError *error;
	[self backAndReturnError:&error];
}

-(void) backAndReturnError:(NSError**)error
{
	[self.jsonWireClient postBackWithSession:self.session.sessionId error:error];
}

-(void) refresh
{
	NSError *error;
	[self refreshAndReturnError:&error];
}

-(void) refreshAndReturnError:(NSError**)error
{
	[self.jsonWireClient postRefreshWithSession:self.session.sessionId error:error];
}

-(NSImage*) screenshot
{
	NSError *error;
	return [self screenshotAndReturnError:&error];
}

-(NSImage*) screenshotAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getScreenshotWithSession:self.session.sessionId error:error];
}

-(NSString*) pageSource
{
    NSError *error;
    return [self pageSourceAndReturnError:&error];
}

-(NSString*) pageSourceAndReturnError:(NSError **)error
{
	return [self.jsonWireClient getSourceWithSession:self.session.sessionId error:error];
}

-(NSString*) title
{
    NSError *error;
	return [self titleAndReturnError:&error];
}

-(NSString*) titleAndReturnError:(NSError **)error
{
	return [self.jsonWireClient getTitleWithSession:self.session.sessionId error:error];
}

-(WebElement*) findElementBy:(By*)by
{
	NSError *error;
	return [self findElementBy:by error:&error];
}

-(WebElement*) findElementBy:(By*)by error:(NSError**)error
{
	return [self.jsonWireClient postElement:by session:self.session.sessionId error:error];
}

-(NSArray*) findElementsBy:(By*)by
{
	NSError *error;
	return [self findElementsBy:by error:&error];
}

-(NSArray*) findElementsBy:(By*)by error:(NSError**)error
{
	return [self.jsonWireClient postElements:by session:self.session.sessionId error:error];
}

-(WebElement*) activeElement
{
	NSError *error;
	return [self activeElementAndReturnError:&error];
}

-(WebElement*) activeElementAndReturnError:(NSError**)error
{
	return [self.jsonWireClient postActiveElementWithSession:self.session.sessionId error:error];
}

-(SeleniumScreenOrientation) orientation
{
	NSError *error;
	return [self orientationAndReturnError:&error];
}

-(SeleniumScreenOrientation) orientationAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getOrientationWithSession:self.session.sessionId error:error];
}

-(void) setOrientation:(SeleniumScreenOrientation)orientation
{
	NSError* error;
	[self setOrientation:orientation error:&error];
}

-(void) setOrientation:(SeleniumScreenOrientation)orientation error:(NSError**)error
{
	[self.jsonWireClient postOrientation:orientation session:self.session.sessionId error:error];
}

-(NSString*)alertText
{
    NSError *error;
	return [self alertTextAndReturnError:&error];
}

-(NSString*)alertTextAndReturnError:(NSError **)error
{
	return [self.jsonWireClient getAlertTextWithSession:self.session.sessionId error:error];
}

-(void) setAlertText:(NSString*)text
{
	NSError* error;
	[self setAlertText:text error:&error];
}

-(void) setAlertText:(NSString*)text error:(NSError**)error
{
	[self.jsonWireClient postAlertText:text session:self.session.sessionId error:error];
}

-(void) acceptAlert
{
	NSError *error;
	[self acceptAlertAndReturnError:&error];
}

-(void) acceptAlertAndReturnError:(NSError**)error
{
	[self.jsonWireClient postAcceptAlertWithSession:self.session.sessionId error:error];
}

-(void) dismissAlert
{
	NSError *error;
	[self dismissAlertAndReturnError:&error];
}

-(void) dismissAlertAndReturnError:(NSError**)error
{
	[self.jsonWireClient postDismissAlertWithSession:self.session.sessionId error:error];
}

@end
