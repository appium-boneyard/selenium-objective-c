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

-(NSString*) tagName
{
	NSError *error;
	return [self tagNameAndReturnError:&error];
}

-(NSString*) tagNameAndReturnError:(NSError**)error
{
	return [[self client] getElementName:self session:[self sessionId] error:error];
}

-(void) clear
{
	NSError *error;
	[self clearAndReturnError:&error];
}

-(void) clearAndReturnError:(NSError**)error
{
	[[self client] postClearElement:self session:[self sessionId] error:error];
}

-(BOOL) isSelected
{
	NSError *error;
	return [self isSelectedAndReturnError:&error];
}

-(BOOL) isSelectedAndReturnError:(NSError**)error
{
	return [[self client] getElementIsSelected:self session:[self sessionId] error:error];
}

-(BOOL) isEnabled
{
	NSError *error;
	return [self isEnabledAndReturnError:&error];
}

-(BOOL) isEnabledAndReturnError:(NSError**)error
{
	return [[self client] getElementIsEnabled:self session:[self sessionId] error:error];
}

-(NSString*) attribute:(NSString*)attributeName
{
	NSError *error;
	return [self attribute:attributeName error:&error];
}

-(NSString*) attribute:(NSString*)attributeName error:(NSError**)error
{
	return [[self client] getAttribute:attributeName element:self session:[self sessionId] error:error];
}

-(BOOL) isEqualToElement:(WebElement*)element
{
	NSError *error;
	return [self isEqualToElement:element error:&error];
}

-(BOOL) isEqualToElement:(WebElement*)element error:(NSError**)error
{
	return [[self client] getEqualityForElement:self element:element session:[self sessionId] error:error];
}

-(BOOL) isDisplayed
{
	NSError *error;
	return [self isDisplayedAndReturnError:&error];
}

-(BOOL) isDisplayedAndReturnError:(NSError**)error
{
	return [[self client] getElementIsDisplayed:self session:[self sessionId] error:error];
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
