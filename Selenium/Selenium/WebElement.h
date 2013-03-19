//
//  WebElement.h
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONWireClient.h"
#import "By.h"

@class JSONWireClient;
@class By;

@interface WebElement : NSObject

@property NSString *opaqueId;
@property JSONWireClient *client;
@property NSString *sessionId;

- (id)initWithOpaqueId:(NSString*)opaqueId jsonWireClient:(JSONWireClient*)jsonWireClient session:(NSString*)remoteSessionId;

-(void) click;
-(void) clickAndReturnError:(NSError**)error;
-(WebElement*) findElementBy:(By*)by;
-(WebElement*) findElementBy:(By*)by error:(NSError**)error;
-(NSArray*) findElementsBy:(By*)by;
-(NSArray*) findElementsBy:(By*)by error:(NSError**)error;

@end
