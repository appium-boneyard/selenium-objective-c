//
//  Selenium.m
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "WebDriver.h"
#import "Status.h"

@implementation WebDriver

NSString *serverAddress;
NSInteger serverPort;

-(NSString*)httpCommandExecutor
{
    return [NSString stringWithFormat:@"http://%@:%d/wd/hub", serverAddress, (int)serverPort];
}

- (id)initWithServerAddress:(NSString*)address port:(NSInteger)port
{
    self = [super init];
    if (self) {
        serverAddress = address;
        serverPort = port;
        [self status];
    }
    return self;
}

-(Status*)status
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@/status", [self httpCommandExecutor]]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSURLResponse *response;
    NSError *error;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    return [[Status alloc] initWithJSON:urlData];
}

@end
