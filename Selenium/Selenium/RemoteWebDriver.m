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
#import "JSONWireClient.h"

@implementation RemoteWebDriver

JSONWireClient *jsonWireClient;

#pragma mark - Public Methods

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(Capabilities*)desiredCapabilities requiredCapabilities:(Capabilities*)requiredCapabilites error:(NSError**)error
{
    self = [super init];
    if (self) {
        jsonWireClient = [[JSONWireClient alloc] initWithServerAddress:address port:port desiredCapabilities:desiredCapabilities requiredCapabilities:requiredCapabilites error:error];
		
		// get session
		[self setSession:[jsonWireClient postSessionWithDesiredCapabilities:desiredCapabilities andRequiredCapabilities:requiredCapabilites error:error]];
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
	[jsonWireClient deleteSessionWithSession:[[self session] sessionID] error:error];
}

-(NSString*) windowHandle
{
	NSError *error;
	return [self windowHandleAndReturnError:&error];
}

-(NSString*) windowHandleAndReturnError:(NSError**)error
{
	return [jsonWireClient getWindowHandleWithSession:[[self session] sessionID] error:error];
}

-(NSArray*) windowHandles
{
	NSError *error;
	return [self windowHandlesAndReturnError:&error];
}

-(NSArray*) windowHandlesAndReturnError:(NSError**)error
{
	return [jsonWireClient getWindowHandlesWithSession:[[self session] sessionID] error:error];
}

-(NSURL*) url
{
	NSError *error;
	return [self urlAndReturnError:&error];
}

-(NSURL*) urlAndReturnError:(NSError**)error
{
    return [jsonWireClient getURLWithSession:[[self session] sessionID] error:error];
}

-(void) setUrl:(NSURL*)url
{
	NSError *error;
	return [self setUrl:url error:&error];
}

-(void) setUrl:(NSURL*)url error:(NSError**)error
{
	[jsonWireClient postURL:url session:[[self session] sessionID] error:error];
}

-(void) forward
{
	NSError *error;
	[self forwardAndReturnError:&error];
}

-(void) forwardAndReturnError:(NSError**)error
{
	[jsonWireClient postForwardWithSession:[[self session] sessionID] error:error];
}

-(void) back
{
	NSError *error;
	[self backAndReturnError:&error];
}

-(void) backAndReturnError:(NSError**)error
{
	[jsonWireClient postBackWithSession:[[self session] sessionID] error:error];
}

-(void) refresh
{
	NSError *error;
	[self refreshAndReturnError:&error];
}

-(void) refreshAndReturnError:(NSError**)error
{
	[jsonWireClient postRefreshWithSession:[[self session] sessionID] error:error];
}

-(NSString*)pageSource
{
    NSError *error;
    return [self pageSourceAndReturnError:&error];
}

-(NSString*)pageSourceAndReturnError:(NSError **)error
{
	return [jsonWireClient getSourceWithSession:[[self session] sessionID] error:error];
}

-(NSString*)title
{
    NSError *error;
	return [self titleAndReturnError:&error];
}

-(NSString*)titleAndReturnError:(NSError **)error
{
	return [jsonWireClient getTitleWithSession:[[self session] sessionID] error:error];
}

-(WebElement*)findElementBy:(By*)by
{
	NSError *error;
	return [self findElementBy:by error:&error];
}

-(WebElement*)findElementBy:(By*)by error:(NSError**)error
{
	return [jsonWireClient postElement:by session:[[self session] sessionID] error:error];
}

-(NSArray*)findElementsBy:(By*)by
{
	NSError *error;
	return [self findElementsBy:by error:&error];
}

-(NSArray*)findElementsBy:(By*)by error:(NSError**)error
{
	return [jsonWireClient postElements:by session:[[self session] sessionID] error:error];
}

-(WebElement*)activeElement
{
	NSError *error;
	return [self activeElementAndReturnError:&error];
}

-(WebElement*)activeElementAndReturnError:(NSError**)error
{
	return [jsonWireClient postActiveElementWithSession:[[self session] sessionID] error:error];
}

-(ScreenOrientation) orientation
{
	NSError *error;
	return [self orientationAndReturnError:&error];
}

-(ScreenOrientation) orientationAndReturnError:(NSError**)error
{
	return [jsonWireClient getOrientationWithSession:[[self session] sessionID] error:error];
}

-(void) setOrientation:(ScreenOrientation)orientation
{
	NSError* error;
	[self setOrientation:orientation error:&error];
}

-(void) setOrientation:(ScreenOrientation)orientation error:(NSError**)error
{
	[jsonWireClient postOrientation:orientation session:[[self session] sessionID] error:error];
}

-(NSString*)alertText
{
    NSError *error;
	return [self alertTextAndReturnError:&error];
}

-(NSString*)alertTextAndReturnError:(NSError **)error
{
	return [jsonWireClient getAlertTextWithSession:[[self session] sessionID] error:error];
}

-(void) setAlertText:(NSString*)text
{
	NSError* error;
	[self setAlertText:text error:&error];
}

-(void) setAlertText:(NSString*)text error:(NSError**)error
{
	[jsonWireClient postAlertText:text session:[[self session] sessionID] error:error];
}

-(void) acceptAlert
{
	NSError *error;
	[self acceptAlertAndReturnError:&error];
}

-(void) acceptAlertAndReturnError:(NSError**)error
{
	[jsonWireClient postAcceptAlertWithSession:[[self session] sessionID] error:error];
}

-(void) dismissAlert
{
	NSError *error;
	[self dismissAlertAndReturnError:&error];
}

-(void) dismissAlertAndReturnError:(NSError**)error
{
	[jsonWireClient postDismissAlertWithSession:[[self session] sessionID] error:error];
}

@end
