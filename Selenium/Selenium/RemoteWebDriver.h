//
//  Selenium.h
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Capabilities.h"
#import "By.h"
#import "WebElement.h"
#import "RemoteWebDriverSession.h"

@class Capabilities;
@class By;
@class WebElement;
@class RemoteWebDriverSession;

@interface RemoteWebDriver : NSObject

@property RemoteWebDriverSession *session;

-(id) initWithServerAddress:(NSString*)address port:(NSInteger)port desiredCapabilities:(Capabilities*)desiredCapabilities requiredCapabilities:(Capabilities*)requiredCapabilites error:(NSError**)error;

-(void) quit;
-(void) quitAndError:(NSError**)error;

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

@end
