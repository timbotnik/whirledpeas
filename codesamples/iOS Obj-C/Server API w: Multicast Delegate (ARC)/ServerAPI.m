//
//  ServerAPI.m
//
//  Created by Tim Hingston on 8/25/13.
//  Copyright 2013 Tim Hingston. All rights reserved.
//

#import "ServerAPI.h"
#import "SBJson.h"
#import "NSDataAdditions.h"
#import "AFJSONRequestOperation.h"
#import "ServerApiClient.h"
#import "UserState.h"

#define API_BASE @"https://admin.tvdj.co/mobileserver/"

@interface ServerAPI()

-(void)startKeepAlive;
-(void)stopKeepAlive;
-(void)sendKeepAlive;

@end

@implementation ServerAPI

+(ServerAPI *)sharedInstance
{
    static dispatch_once_t onceToken;
    static ServerAPI *sharedInstanceDelegate = nil;
    dispatch_once(&onceToken, ^{
        sharedInstanceDelegate = [[self alloc] initWithBaseURL:[NSURL URLWithString:API_BASE]];
        sharedInstanceDelegate.defaultClient = [[ServerApiClient alloc] init];
        sharedInstanceDelegate.delegates = (EventSource<ServerApiDelegate>*)[[EventSource alloc] initWithDefaultSink:sharedInstanceDelegate.defaultClient];
    });
    return sharedInstanceDelegate;
}

-(void) dealloc
{
    [self stopKeepAlive];
    [self.delegates removeAll];
    self.defaultClient = nil;
    self.delegates = nil;
}

-(BOOL)isSuccess:(id)response :(NSError**)error
{
    NSNumber* success = [response objectForKey:@"success"];
    if (success) {
        if (success.intValue != 0) {
            *error = nil;
            return YES;
        }
        else {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            NSString* message = [response objectForKey:@"message"];
            [details setValue:message forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:@"SmartphadeAPI" code:1 userInfo:details];
        }
    }
    else {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Unknown Error" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"SmartphadeAPI" code:1 userInfo:details];
    }
    return NO;
}

#pragma mark User APIs
-(void)registerUser:(NSDictionary *)dict
{
    NSURLRequest *request = [self requestWithMethod:@"POST" path:@"register" parameters:dict];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        NSLog(@"Register Response: %@", json);
        NSError* error;
        if ([self isSuccess:json :&error]) {
            [self.delegates onRegisterResponse:json withError:nil];
        }
        else {
            [self.delegates onRegisterResponse:nil withError:error];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError* error, id json) {
        [self.delegates onRegisterResponse:nil withError:error];
    }];
    [self enqueueHTTPRequestOperation:operation];
}

-(void)registerSocialUser:(NSDictionary *)dict
{
    NSURLRequest *request = [self requestWithMethod:@"POST" path:@"registerSocial" parameters:dict];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        NSLog(@"Register Response: %@", json);
        NSError* error;
        if ([self isSuccess:json :&error]) {
            [self.delegates onRegisterResponse:json withError:nil];
        }
        else {
            [self.delegates onRegisterResponse:nil withError:error];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError* error, id json) {
        [self.delegates onRegisterResponse:nil withError:error];
    }];
    [self enqueueHTTPRequestOperation:operation];
}

-(void)login:(NSString *)userName  password:(NSString *)pwd
{
    NSURLRequest *request = [self requestWithMethod:@"POST" path:@"login" parameters:[NSDictionary dictionaryWithObjectsAndKeys:userName, @"user_name", pwd, @"password", nil]];
    
    NSLog(@"Login: %@", userName);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        NSLog(@"Login Response: %@", json);
        NSError* error;
        if ([self isSuccess:json :&error]) {
            // TBD: check to make sure response has proper keys
            NSDictionary* info = [json objectForKey:@"data"];
            UserState* state = [UserState sharedInstance];
            state.userId = [info objectForKey:@"id"];
            state.authToken = [info objectForKey:@"auth_token"];
            [state save];
            if (state.userId != nil && state.authToken != nil && state.deviceToken != nil) {
                [self clearAuthorizationHeader];
                [self setAuthorizationHeaderWithUsername:state.userId password:state.authToken];
            }
            _isLoggedIn = YES;
            [self connect];
            [self.delegates onLoginResponse:json withError:nil];
        }
        else {
            _isLoggedIn = NO;
            [self.delegates onLoginResponse:nil withError:error];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError* error, id json) {
        NSLog(@"Login Response: %@", json);
        [self.delegates onLoginResponse:nil withError:error];
    }];
    [self enqueueHTTPRequestOperation:operation];
}

-(void)logout:(NSString*)userid authToken:(NSString *)authToken
{
    NSURLRequest *request = [self requestWithMethod:@"POST" path:@"logout" parameters:[NSDictionary dictionaryWithObjectsAndKeys:userid, @"user_id", authToken, @"auth_token", nil]];
    _isLoggedIn = NO;
    [self disconnect];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        [self clearAuthorizationHeader];
        NSLog(@"Logout Response: %@", json);
        NSError* error;
        if ([self isSuccess:json :&error]) {
            [self.delegates onLogoutResponse:json withError:nil];
        }
        else {
            [self.delegates onLogoutResponse:nil withError:error];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError* error, id json) {
        [self clearAuthorizationHeader];
        [self.delegates onLogoutResponse:nil withError:error];
    }];
    [self enqueueHTTPRequestOperation:operation];
}

-(void)updateDeviceToken:(NSString*)userid authToken:(NSString *)authToken deviceToken:(NSString *)deviceToken
{
    NSURLRequest *request = [self requestWithMethod:@"POST" path:@"updatedevicetoken" parameters:[NSDictionary dictionaryWithObjectsAndKeys:userid, @"user_id", authToken, @"auth_token", deviceToken, @"device_token", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        NSLog(@"Update Device Token Response: %@", json);
        NSError* error;
        if ([self isSuccess:json :&error]) {
            [self.delegates onUpdateDeviceTokenResponse:json withError:nil];
        }
        else {
            [self.delegates onUpdateDeviceTokenResponse:nil withError:error];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError* error, id json) {
        [self.delegates onUpdateDeviceTokenResponse:nil withError:error];
    }];
    [self enqueueHTTPRequestOperation:operation];
}


#pragma mark Subscription APIs
-(void)getProviderList
{   
    NSURLRequest *request = [self requestWithMethod:@"GET" path:@"listprovider" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        NSLog(@"Provider List Response: %@", json);
        NSError* error;
        if ([self isSuccess:json :&error]) {
            [self.delegates onProviderListResponse:json withError:nil];
        }
        else {
            [self.delegates onProviderListResponse:nil withError:error];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError* error, id json) {
        [self.delegates onProviderListResponse:nil withError:error];
    }];
    [self enqueueHTTPRequestOperation:operation];
}

-(void)getChannelList
{
    NSURLRequest *request = [self requestWithMethod:@"GET" path:@"listchannels" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        NSLog(@"Channel List Response: %@", json);
        NSError* error;
        if ([self isSuccess:json :&error]) {
            [self.delegates onChannelListResponse:json withError:nil];
        }
        else {
            [self.delegates onChannelListResponse:nil withError:error];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError* error, id json) {
        [self.delegates onChannelListResponse:nil withError:error];
    }];
    [self enqueueHTTPRequestOperation:operation];
}

-(void)subscribeToChannel:(NSMutableDictionary *)dict
{
    NSDictionary* subData = [NSDictionary dictionaryWithObjectsAndKeys:
                             [dict valueForKey:@"remote_id"], @"remote_id",
                             [dict valueForKey:@"channel_id"], @"channel_id",
                             nil];
    NSURLRequest *request = [self requestWithMethod:@"POST" path:@"updatestatus" parameters:subData];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        NSLog(@"Subscribe Response: %@", json);
        NSError* error;
        if ([self isSuccess:json :&error]) {
            [self.delegates onSubscribeResponse:json withError:nil];
        }
        else {
            [self.delegates onSubscribeResponse:nil withError:error];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError* error, id json) {
        [self.delegates onSubscribeResponse:nil withError:error];
    }];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)connect
{
    [self startKeepAlive];
}

- (void)disconnect
{
    [self stopKeepAlive];
}

#pragma mark Private Methods
- (void)startKeepAlive
{
    if (_keepAliveTimer) {
        [self stopKeepAlive];
    }
    _keepAliveTimer = [NSTimer scheduledTimerWithTimeInterval: 30.0
                                                       target: self
                                                     selector:@selector(sendKeepAlive)
                                                     userInfo: nil repeats:YES];
}

- (void)stopKeepAlive
{
    if (_keepAliveTimer) {
        [_keepAliveTimer invalidate];
        _keepAliveTimer = nil;
    }
}

-(void)sendKeepAlive
{
    NSDictionary* subscription = [[UserState sharedInstance] getCurrentSubscription];
    if (subscription == nil) {
        NSLog(@"Keep-alive running but no subscription!");
        return;
    }
    
    NSURLRequest *request = [self requestWithMethod:@"POST" path:@"updatestatus" parameters:subscription];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        NSLog(@"Keep-alive Response: %@", json);
        NSError* error;
        if ([self isSuccess:json :&error]) {
            [self.delegates onKeepAliveResponse:json withError:nil];
        }
        else {
            [self.delegates onKeepAliveResponse:nil withError:error];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError* error, id json) {
        [self.delegates onKeepAliveResponse:nil withError:error];
    }];
    [self enqueueHTTPRequestOperation:operation];
}

@end