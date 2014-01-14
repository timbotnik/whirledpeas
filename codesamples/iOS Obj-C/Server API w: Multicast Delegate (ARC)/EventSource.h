//
//  EventSource.h
//
//  Created by Tim Hingston on 8/25/13.
//  Copyright 2013 Tim Hingston. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EventSource : NSObject {
    NSMutableArray* delegates;
    id defaultSink;
}

- (id)initWithDefaultSink: (id)object;
- (void)subscribe: (id)object;
- (void)unsubscribe: (id)object;
- (void)removeAll;

- (BOOL)respondsToSelector:(SEL)aSelector;
- ( NSMethodSignature * )methodSignatureForSelector: ( SEL )selector;
- ( void )forwardInvocation: ( NSInvocation * )invocation;

@end
