//
//  WebElement.m
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "WebElement.h"

@interface WebElement ()
	@property JSONWireClient *jsonWireClient;
@end

@implementation WebElement 

-(id) initWithOpaqueId:(NSString*)opaqueId jsonWireClient:(JSONWireClient*)jsonWireClient session:(NSString*)sessionId
{
    self = [super init];
    if (self) {
        [self setOpaqueId:opaqueId];
		[self setJsonWireClient:jsonWireClient];
		[self setSessionId:sessionId];
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
	[self.jsonWireClient postClickElement:self session:self.sessionId error:error];
}

-(void) submit
{
	NSError *error;
	[self submitAndReturnError:&error];
}

-(void) submitAndReturnError:(NSError**)error
{
	[self.jsonWireClient postSubmitElement:self session:self.sessionId error:error];
}

-(NSString*) text
{
	NSError *error;
	return [self textAndReturnError:&error];
}

-(NSString*) textAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementText:self session:self.sessionId error:error];
}

-(NSString*) tagName
{
	NSError *error;
	return [self tagNameAndReturnError:&error];
}

-(NSString*) tagNameAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementName:self session:self.sessionId error:error];
}

-(void) clear
{
	NSError *error;
	[self clearAndReturnError:&error];
}

-(void) clearAndReturnError:(NSError**)error
{
	[self.jsonWireClient postClearElement:self session:self.sessionId error:error];
}

-(BOOL) isSelected
{
	NSError *error;
	return [self isSelectedAndReturnError:&error];
}

-(BOOL) isSelectedAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementIsSelected:self session:self.sessionId error:error];
}

-(BOOL) isEnabled
{
	NSError *error;
	return [self isEnabledAndReturnError:&error];
}

-(BOOL) isEnabledAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementIsEnabled:self session:self.sessionId error:error];
}

-(NSString*) attribute:(NSString*)attributeName
{
	NSError *error;
	return [self attribute:attributeName error:&error];
}

-(NSString*) attribute:(NSString*)attributeName error:(NSError**)error
{
	return [self.jsonWireClient getAttribute:attributeName element:self session:self.sessionId error:error];
}

-(BOOL) isEqualToElement:(WebElement*)element
{
	NSError *error;
	return [self isEqualToElement:element error:&error];
}

-(BOOL) isEqualToElement:(WebElement*)element error:(NSError**)error
{
	return [self.jsonWireClient getEqualityForElement:self element:element session:self.sessionId error:error];
}

-(BOOL) isDisplayed
{
	NSError *error;
	return [self isDisplayedAndReturnError:&error];
}

-(BOOL) isDisplayedAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementIsDisplayed:self session:self.sessionId error:error];
}

-(NSPoint) location
{
	NSError *error;
	return [self locationAndReturnError:&error];
}

-(NSPoint) locationAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementLocation:self session:self.sessionId error:error];
}

-(NSPoint) locationInView
{
	NSError *error;
	return [self locationInViewAndReturnError:&error];
}

-(NSPoint) locationInViewAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementLocationInView:self session:self.sessionId error:error];
}

-(NSSize) size
{
	NSError *error;
	return [self sizeAndReturnError:&error];
}

-(NSSize) sizeAndReturnError:(NSError**)error
{
	return [self.jsonWireClient getElementSize:self session:self.sessionId error:error];
}

-(NSString*) cssProperty:(NSString*)propertyName
{
	NSError *error;
	return [self cssProperty:propertyName error:&error];
}

-(NSString*) cssProperty:(NSString*)propertyName error:(NSError**)error
{
	return [self.jsonWireClient getCSSProperty:propertyName element:self session:self.sessionId error:error];
}

-(WebElement*) findElementBy:(By*)by
{
	NSError *error;
	return [self findElementBy:by error:&error];
}

-(WebElement*) findElementBy:(By*)by error:(NSError**)error
{
	return [self.jsonWireClient postElementFromElement:self by:by session:self.sessionId error:error];
}

-(NSArray*) findElementsBy:(By*)by
{
	NSError *error;
	return [self findElementsBy:by error:&error];
}

-(NSArray*) findElementsBy:(By*)by error:(NSError**)error
{
	return [self.jsonWireClient postElementsFromElement:self by:by session:self.sessionId error:error];
}

@end
