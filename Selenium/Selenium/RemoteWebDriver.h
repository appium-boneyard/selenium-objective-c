//
//  Selenium.h
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeleniumCapabilities.h"
#import "By.h"
#import "WebElement.h"
#import "RemoteWebDriverSession.h"
#import "SeleniumEnums.h"

@class SeleniumCapabilities;
@class By;
@class WebElement;
@class RemoteWebDriverSession;

@interface RemoteWebDriver : NSObject

@property RemoteWebDriverSession *session;

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(SeleniumCapabilities*)desiredCapabilities requiredCapabilities:(SeleniumCapabilities*)requiredCapabilites error:(NSError**)error;

-(void) quit;
-(void) quitAndError:(NSError**)error;
-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(SeleniumTimeoutType)type;
-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(SeleniumTimeoutType)type error:(NSError**)error;
-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds;
-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds error:(NSError**)error;
-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds;
-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds error:(NSError**)error;
-(NSString*) windowHandle;
-(NSString*) windowHandleAndReturnError:(NSError**)error;
-(NSArray*) windowHandles;
-(NSArray*) windowHandlesAndReturnError:(NSError**)error;

-(NSURL*) url;
-(NSURL*) urlAndReturnError:(NSError**)error;
-(void) setUrl:(NSURL*)url;
-(void) setUrl:(NSURL*)url error:(NSError**)error;
-(void) forward;
-(void) forwardAndReturnError:(NSError**)error;
-(void) back;
-(void) backAndReturnError:(NSError**)error;
-(void) refresh;
-(void) refreshAndReturnError:(NSError**)error;

-(NSImage*) screenshot;
-(NSImage*) screenshotAndReturnError:(NSError**)error;
-(NSArray*) availableInputMethodEngines;
-(NSArray*) availableInputMethodEnginesAndReturnError:(NSError**)error;
-(NSString*) activeInputMethodEngine;
-(NSString*) activeInputMethodEngineAndReturnError:(NSError **)error;
-(BOOL) inputMethodEngineIsActive;
-(BOOL) inputMethodEngineIsActiveAndReturnError:(NSError **)error;
-(void) deactivateInputMethodEngine;
-(void) deactivateInputMethodEngineAndReturnError:(NSError **)error;
-(void) activateInputMethodEngine:(NSString*)engine;
-(void) activateInputMethodEngine:(NSString*)engine error:(NSError **)error;
-(void) setFrame:(id)name;
-(void) setFrame:(id)name error:(NSError**)error;
-(void) setWindow:(NSString*)windowHandle;
-(void) setWindow:(NSString*)windowHandle error:(NSError**)error;
-(void) closeWindow:(NSString*)windowHandle;
-(void) closeWindow:(NSString*)windowHandle error:(NSError**)error;
-(void) setWindowSize:(NSSize)size window:(NSString*)windowHandle;
-(void) setWindowSize:(NSSize)size window:(NSString*)windowHandle error:(NSError**)error;
-(NSSize) windowSizeWithWindow:(NSString*)windowHandle;
-(NSSize) windowSizeWithWindow:(NSString*)windowHandle error:(NSError**)error;
-(void) setWindowPosition:(NSPoint)position window:(NSString*)windowHandle;
-(void) setWindowPosition:(NSPoint)position window:(NSString*)windowHandle error:(NSError**)error;
-(NSPoint) windowPositionWithWindow:(NSString*)windowHandle;
-(NSPoint) windowPositionWithWindow:(NSString*)windowHandle error:(NSError**)error;
-(void) maximizeWindow:(NSString*)windowHandle;
-(void) maximizeWindow:(NSString*)windowHandle error:(NSError**)error;
-(NSArray*) cookies;
-(NSArray*) cookiesAndReturnError:(NSError**)error;
-(void) setCookie:(NSHTTPCookie*)cookie;
-(void) setCookie:(NSHTTPCookie*)cookie error:(NSError**)error;
-(void) deleteCookies;
-(void) deleteCookiesAndReturnError:(NSError**)error;
-(void) deleteCookie:(NSString*)cookieName;
-(void) deleteCookie:(NSString*)cookieName error:(NSError**)error;

-(NSString*) pageSource;
-(NSString*) pageSourceAndReturnError:(NSError**)error;
-(NSString*) title;
-(NSString*) titleAndReturnError:(NSError **)error;
-(WebElement*) findElementBy:(By*)by;
-(WebElement*) findElementBy:(By*)by error:(NSError**)error;
-(NSArray*) findElementsBy:(By*)by;
-(NSArray*) findElementsBy:(By*)by error:(NSError**)error;
-(WebElement*) activeElement;
-(WebElement*) activeElementAndReturnError:(NSError**)error;
-(void) sendKeys:(NSString*)keyString;
-(void) sendKeys:(NSString*)keyString error:(NSError**)error;
-(SeleniumScreenOrientation) orientation;
-(SeleniumScreenOrientation) orientationAndReturnError:(NSError**)error;
-(void) setOrientation:(SeleniumScreenOrientation)orientation;
-(void) setOrientation:(SeleniumScreenOrientation)orientation error:(NSError**)error;
-(NSString*)alertText;
-(NSString*)alertTextAndReturnError:(NSError **)error;
-(void) setAlertText:(NSString*)text;
-(void) setAlertText:(NSString*)text error:(NSError**)error;
-(void) acceptAlert;
-(void) acceptAlertAndReturnError:(NSError**)error;
-(void) dismissAlert;
-(void) dismissAlertAndReturnError:(NSError**)error;

@end
