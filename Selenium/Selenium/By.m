//
//  By.m
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "By.h"

@implementation By

-(id) initWithLocationStrategy:(NSString*)locationStrategy value:(NSString*)value
{
    self = [super init];
    if (self) {
        [self setLocationStrategy:locationStrategy];
		[self setValue:value];
    }
    return self;
}

+(By*) className:(NSString*)className
{
	return [[By alloc] initWithLocationStrategy:@"class name" value:className];
}

+(By*) cssSelector:(NSString*)cssSelector
{
	return [[By alloc] initWithLocationStrategy:@"css selector" value:cssSelector];
}

+(By*) idString:(NSString*)idString
{
	return [[By alloc] initWithLocationStrategy:@"id" value:idString];
}

+(By*) name:(NSString*)name
{
	return [[By alloc] initWithLocationStrategy:@"name" value:name];
}

+(By*) linkText:(NSString*)linkText
{
	return [[By alloc] initWithLocationStrategy:@"link text" value:linkText];
}

+(By*) partialLinkText:(NSString*)partialLinkText
{
	return [[By alloc] initWithLocationStrategy:@"partial link text" value:partialLinkText];
}

+(By*) tagName:(NSString*)tagName
{
	return [[By alloc] initWithLocationStrategy:@"tag name" value:tagName];
}

+(By*) xPath:(NSString*)xPath
{
	return [[By alloc] initWithLocationStrategy:@"xpath" value:xPath];
}

@end
