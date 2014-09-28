//
//  SEWebElement.h
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEJsonWireClient.h"
#import "SEBy.h"

@class SEJsonWireClient;
@class SEBy;

@interface SEWebElement : NSObject

@property NSString *opaqueId;
@property NSString *sessionId;
@property (readonly) NSString *text;
@property (readonly) BOOL isDisplayed;
@property (readonly) BOOL isEnabled;
@property (readonly) BOOL isSelected;
@property (readonly) NSPoint location;
@property (readonly) NSPoint locationInView;
@property (readonly) NSSize size;
@property (readonly) NSDictionary *elementJson;

-(id) initWithOpaqueId:(NSString*)opaqueId jsonWireClient:(SEJsonWireClient*)jsonWireClient session:(NSString*)sessionId;

-(void) click;
-(void) clickAndReturnError:(NSError**)error;
-(void) submit;
-(void) submitAndReturnError:(NSError**)error;
-(NSString*) text;
-(NSString*) textAndReturnError:(NSError**)error;
-(void) sendKeys:(NSString*)keyString;
-(void) sendKeys:(NSString*)keyString error:(NSError**)error;
-(NSString*) tagName;
-(NSString*) tagNameAndReturnError:(NSError**)error;
-(void) clear;
-(void) clearAndReturnError:(NSError**)error;
-(BOOL) isSelected;
-(BOOL) isSelectedAndReturnError:(NSError**)error;
-(BOOL) isEnabled;
-(BOOL) isEnabledAndReturnError:(NSError**)error;
-(NSString*) attribute:(NSString*)attributeName;
-(NSString*) attribute:(NSString*)attributeName error:(NSError**)error;
-(BOOL) isEqualToElement:(SEWebElement*)element;
-(BOOL) isEqualToElement:(SEWebElement*)element error:(NSError**)error;
-(BOOL) isDisplayed;
-(BOOL) isDisplayedAndReturnError:(NSError**)error;
-(NSPoint) location;
-(NSPoint) locationAndReturnError:(NSError**)error;
-(NSPoint) locationInView;
-(NSPoint) locationInViewAndReturnError:(NSError**)error;
-(NSSize) size;
-(NSSize) sizeAndReturnError:(NSError**)error;
-(NSString*) cssProperty:(NSString*)propertyName;
-(NSString*) cssProperty:(NSString*)propertyName error:(NSError**)error;

-(SEWebElement*) findElementBy:(SEBy*)by;
-(SEWebElement*) findElementBy:(SEBy*)by error:(NSError**)error;
-(NSArray*) findElementsBy:(SEBy*)by;
-(NSArray*) findElementsBy:(SEBy*)by error:(NSError**)error;

-(NSDictionary*)elementJson;

-(void) setValue:(NSString*)value;
-(void) setValue:(NSString*)value isUnicode:(BOOL)isUnicode;
-(void) setValue:(NSString*)value isUnicode:(BOOL)isUnicode error:(NSError**)error;

-(void) replaceValue:(NSString*)value element:(SEWebElement*)element;
-(void) replaceValue:(NSString*)value element:(SEWebElement*)element isUnicode:(BOOL)isUnicode;
-(void) replaceValue:(NSString*)value isUnicode:(BOOL)isUnicode error:(NSError**)error;

@end
