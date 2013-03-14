//
//  Selenium.m
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "RemoteWebDriver.h"
#import "RemoteWebDriverStatus.h"

@implementation RemoteWebDriver

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
        [self getStatus];
    }
    return self;
}

-(RemoteWebDriverStatus*)getStatus
{
	NSString *urlString = [NSString stringWithFormat:@"%@/status", [self httpCommandExecutor]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSURLResponse *response;
    NSError *error;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    return [[RemoteWebDriverStatus alloc] initWithJSON:urlData];
}

-(void)postSesssionWithDesiredCapabilities:(NSString*)desiredCapabilities andRequiredCapabilities:(NSString*)requiredCapabilities
{
	NSString *urlString = [NSString stringWithFormat:@"%@/session", [self httpCommandExecutor]];
	NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	NSString *post =[[NSString alloc] initWithFormat:@"desiredCapabilities=%@",desiredCapabilities];
	if (requiredCapabilities != nil)
	{
		post = [post stringByAppendingString:[NSString stringWithFormat:@"&=requiredCapabilities%@", requiredCapabilities]];
	}
	
	[request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLResponse *response;
	NSError *err;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
}

@end
