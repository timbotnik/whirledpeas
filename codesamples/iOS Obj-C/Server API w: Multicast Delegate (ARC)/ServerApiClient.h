//
//  ServerApiClient.h
//  TVDJ
//
//  Created by Tim Hingston on 8/25/13.
//  Copyright (c) 2013 Tim Hingston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerAPI.h"

@interface ServerApiClient : NSObject<ServerApiDelegate>

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
