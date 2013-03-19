//
//  WebElement.h
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSONWireClient;

@interface WebElement : NSObject

@property NSString *opaqueId;
@property JSONWireClient *client;
@property NSString *sessionId;

- (id)initWithOpaqueId:(NSString*)opaqueId jsonWireClient:(JSONWireClient*)jsonWireClient session:(NSString*)remoteSessionId;

-(void) click;
-(void) clickAndReturnError:(NSError**)error;

@end
