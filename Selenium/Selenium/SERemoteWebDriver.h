//
//  Selenium.h
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SECapabilities.h"
#import "SEBy.h"
#import "SEWebElement.h"
#import "SESession.h"
#import "SEEnums.h"

@class SECapabilities;
@class SEBy;
@class SEWebElement;
@class SESession;

@interface SERemoteWebDriver : NSObject

@property SESession *session;

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(NSError**)error;

-(void) quit;
-(void) quitAndError:(NSError**)error;
-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(SETimeoutType)type;
-(void) setTimeout:(NSInteger)timeoutInMilliseconds forType:(SETimeoutType)type error:(NSError**)error;
-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds;
-(void) setAsyncScriptTimeout:(NSInteger)timeoutInMilliseconds error:(NSError**)error;
-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds;
-(void) setImplicitWaitTimeout:(NSInteger)timeoutInMilliseconds error:(NSError**)error;
-(NSString*) window;
-(NSString*) windowAndReturnError:(NSError**)error;
-(NSArray*) allWindows;
-(NSArray*) allWindowsAndReturnError:(NSError**)error;
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
-(NSDictionary*) executeScript:(NSString*)script;
-(NSDictionary*) executeScript:(NSString*)script error:(NSError**)error;
-(NSDictionary*) executeScript:(NSString*)script arguments:(NSArray*)arguments;
-(NSDictionary*) executeScript:(NSString*)script arguments:(NSArray*)arguments error:(NSError**)error;
-(NSDictionary*) executeAnsynchronousScript:(NSString*)script;
-(NSDictionary*) executeAnsynchronousScript:(NSString*)script error:(NSError**)error;
-(NSDictionary*) executeAnsynchronousScript:(NSString*)script arguments:(NSArray*)arguments;
-(NSDictionary*) executeAnsynchronousScript:(NSString*)script arguments:(NSArray*)arguments error:(NSError**)error;
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
-(NSSize) windowSizeForWindow:(NSString*)windowHandle;
-(NSSize) windowSizeForWindow:(NSString*)windowHandle error:(NSError**)error;
-(void) setWindowPosition:(NSPoint)position window:(NSString*)windowHandle;
-(void) setWindowPosition:(NSPoint)position window:(NSString*)windowHandle error:(NSError**)error;
-(NSPoint) windowPositionForWindow:(NSString*)windowHandle;
-(NSPoint) windowPositionForWindow:(NSString*)windowHandle error:(NSError**)error;
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
-(SEWebElement*) findElementBy:(SEBy*)by;
-(SEWebElement*) findElementBy:(SEBy*)by error:(NSError**)error;
-(NSArray*) findElementsBy:(SEBy*)by;
-(NSArray*) findElementsBy:(SEBy*)by error:(NSError**)error;
-(SEWebElement*) activeElement;
-(SEWebElement*) activeElementAndReturnError:(NSError**)error;
-(void) sendKeys:(NSString*)keyString;
-(void) sendKeys:(NSString*)keyString error:(NSError**)error;
-(SEScreenOrientation) orientation;
-(SEScreenOrientation) orientationAndReturnError:(NSError**)error;
-(void) setOrientation:(SEScreenOrientation)orientation;
-(void) setOrientation:(SEScreenOrientation)orientation error:(NSError**)error;
-(NSString*)alertText;
-(NSString*)alertTextAndReturnError:(NSError **)error;
-(void) setAlertText:(NSString*)text;
-(void) setAlertText:(NSString*)text error:(NSError**)error;
-(void) acceptAlert;
-(void) acceptAlertAndReturnError:(NSError**)error;
-(void) dismissAlert;
-(void) dismissAlertAndReturnError:(NSError**)error;
-(void) moveMouseWithXOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset;
-(void) moveMouseWithXOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset error:(NSError**)error;
-(void) moveMouseToElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset;
-(void) moveMouseToElement:(SEWebElement*)element xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset error:(NSError**)error;
-(void) click;
-(void) clickAndReturnError:(NSError**)error;
-(void) clickMouseButton:(SEMouseButton)button;
-(void) clickMouseButton:(SEMouseButton)button error:(NSError**)error;
-(void) mouseButtonDown:(SEMouseButton)button;
-(void) mouseButtonDown:(SEMouseButton)button error:(NSError**)error;
-(void) mouseButtonUp:(SEMouseButton)button;
-(void) mouseButtonUp:(SEMouseButton)button error:(NSError**)error;
-(void) doubleclick;
-(void) doubleclickAndReturnError:(NSError**)error;
-(void) tapElement:(SEWebElement*)element;
-(void) tapElement:(SEWebElement*)element error:(NSError**)error;
-(void) fingerDownAt:(NSPoint)point;
-(void) fingerDownAt:(NSPoint)point error:(NSError**)error;
-(void) fingerUpAt:(NSPoint)point;
-(void) fingerUpAt:(NSPoint)point error:(NSError**)error;
-(void) moveFingerTo:(NSPoint)point;
-(void) moveFingerTo:(NSPoint)point error:(NSError**)error;
-(void) doubletapElement:(SEWebElement*)element;
-(void) doubletapElement:(SEWebElement*)element error:(NSError**)error;
-(void) pressElement:(SEWebElement*)element;
-(void) pressElement:(SEWebElement*)element error:(NSError**)error;


-(SEApplicationCacheStatus) applicationCacheStatus;
-(SEApplicationCacheStatus) applicationCacheStatusAndReturnError:(NSError**)error;

@end
