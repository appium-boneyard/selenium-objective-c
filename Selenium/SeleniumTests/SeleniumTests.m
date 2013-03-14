//
//  SeleniumTests.m
//  SeleniumTests
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SeleniumTests.h"
#import "RemoteWebDriver.h"
#import "Capabilities.h"

@implementation SeleniumTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
	/*
	 Capabilities *c = [Capabilities new];
	 [c setVersion:@"6.1"];
	 [c setPlatform:@"Mac"];
	 [c setBrowserName:@"iOS"];
	 RemoteWebDriver *driver = [[RemoteWebDriver alloc] initWithServerAddress:@"127.0.0.1" port:4723 desiredCapabilities:c requiredCapabilities:nil];
	 NSString *pageSource = [driver getPageSource];
	 NSLog(@"%@", pageSource);
	 [driver quit];
	 */
	
	STFail(@"Unit tests are not implemented yet in SeleniumTests");
}

@end
