//
//  WebElement.m
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "WebElement.h"

@implementation WebElement

- (id)initWithOpaqueId:(NSString*)opaqueId
{
    self = [super init];
    if (self) {
        [self setOpaqueId:opaqueId];
    }
    return self;
}

@end
