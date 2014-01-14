//
//  ServerAPI.h
//
//  Created by Tim Hingston on 8/25/13.
//  Copyright 2013 Tim Hingston. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NSObject+SBJson.h"
#import "AFHTTPClient.h"
#import "EventSource.h"

@class ServerApiClient;

@protocol ServerApiDelegate <NSObject>

@optional
- (void) onRegisterResponse:(id)response withError:(NSError*)error;
- (void) onLoginResponse:(id)response withError:(NSError*)error;
- (void) onLogoutResponse:(id)response withError:(NSError*)error;
- (void) onUpdateDeviceTokenResponse:(id)response withError:(NSError*)error;
- (void) onUpdateProfileResponse:(id)response withError:(NSError*)error;
- (void) onProviderListResponse:(id)response withError:(NSError*)error;
- (void) onChannelListResponse:(id)response withError:(NSError*)error;
- (void) onSubscribeResponse:(id)response withError:(NSError*)error;
- (void) onKeepAliveResponse:(id)response withError:(NSError*)error;
@end

@interface ServerAPI : AFHTTPClient {
    NSTimer* _keepAliveTimer;
}

@property (nonatomic, strong) EventSource<ServerApiDelegate>* delegates;
@property (nonatomic, strong) ServerApiClient* defaultClient;
@property (nonatomic, assign) BOOL isLoggedIn;

// SINGLETON SHARED INSTANCE
+(ServerAPI *)sharedInstance;

// USER APIS
-(void)registerUser:(NSDictionary *)dict;
-(void)registerSocialUser:(NSDictionary *)dict;
-(void)login:(NSString *)userName  password:(NSString *)pwd;
-(void)logout:(NSString *)userid  authToken:(NSString *)authToken;
-(void)updateDeviceToken:(NSString*)userid authToken:(NSString*)authToken deviceToken:(NSString*)token;

// SUBSCRIPTION APIS
-(void)getProviderList;
-(void)getChannelList;
-(void)subscribeToChannel:(NSDictionary *)dict;

// CONNECTION APIS
-(void)connect;
-(void)disconnect;

@end
