//
//  WebElement.m
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "WebElement.h"
#import "JSONWireClient.h"

@implementation WebElement

- (id)initWithOpaqueId:(NSString*)opaqueId jsonWireClient:(JSONWireClient*)jsonWireClient session:(NSString*)remoteSessionId
{
    self = [super init];
    if (self) {
        [self setOpaqueId:opaqueId];
		[self setClient:jsonWireClient];
		[self setSessionId:remoteSessionId];
    }
    return self;
}

-(void) click
{
	NSError *error;
	[self clickAndReturnError:&error];
}

-(void) clickAndReturnError:(NSError**)error
{
	[[self client] postClickElement:self session:[self sessionId] error:error];
}

@end
