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

-(id) initWithOpaqueId:(NSString*)opaqueId jsonWireClient:(JSONWireClient*)jsonWireClient session:(NSString*)remoteSessionId
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

-(void) submit
{
	NSError *error;
	[self submitAndReturnError:&error];
}

-(void) submitAndReturnError:(NSError**)error
{
	[[self client] postSubmitElement:self session:[self sessionId] error:error];
}

-(NSString*) text
{
	NSError *error;
	return [self textAndReturnError:&error];
}

-(NSString*) textAndReturnError:(NSError**)error
{
	return [[self client] getElementText:self session:[self sessionId] error:error];
}

-(WebElement*) findElementBy:(By*)by
{
	NSError *error;
	return [self findElementBy:by error:&error];
}

-(WebElement*) findElementBy:(By*)by error:(NSError**)error
{
	return [[self client] postElementFromElement:self by:by session:[self sessionId] error:error];
}

-(NSArray*) findElementsBy:(By*)by
{
	NSError *error;
	return [self findElementsBy:by error:&error];
}

-(NSArray*) findElementsBy:(By*)by error:(NSError**)error
{
	return [[self client] postElementsFromElement:self by:by session:[self sessionId] error:error];
}

@end
