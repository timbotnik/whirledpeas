//
//  EventSource.m
//
//  Created by Tim Hingston on 8/25/13.
//  Copyright 2013 Tim Hingston. All rights reserved.
//

#import "EventSource.h"


@implementation EventSource

- (id)initWithDefaultSink:(id)object
{
    if((self = [super init]))
    {
        delegates = [[NSMutableArray alloc] init];
        [self subscribe:object];
    }
    
    return self;
} 

- (void)dealloc
{
    [self removeAll];
    delegates = nil;
}

- (void)subscribe:(id)object
{
    NSUInteger index = [delegates indexOfObject:object];
    if (index == NSNotFound) {
        [delegates addObject:object];
    }
}

- (void)unsubscribe:(id)object
{
    [delegates removeObject:object];
}

- (void)removeAll
{
    [delegates removeAllObjects];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [self methodSignatureForSelector:aSelector] != nil;
}

- ( NSMethodSignature * )methodSignatureForSelector: ( SEL )selector
{
    NSUInteger i;
    
    for( i = 0; i < [delegates count]; i++ )
    {
        id subscriber = [delegates objectAtIndex:i];
        if( subscriber != nil && [subscriber respondsToSelector: selector ] == YES )
        {
            return [[ subscriber class ] instanceMethodSignatureForSelector: selector ];
        }
    }
    
    return nil;
}

//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    NSUInteger i;
//    
//    for( i = 0; i < [delegates count]; i++ )
//    {
//        id subscriber = [delegates objectAtIndex:i];
//        if( subscriber != nil && [subscriber respondsToSelector: aSelector ] == YES )
//        {
//            return subscriber;
//        }
//    }
//    return defaultSink;
//}

- ( void )forwardInvocation: ( NSInvocation * )invocation
{
    NSUInteger i;
    
    for( i = 0; i < [delegates count]; i++ )
    {
        id subscriber = [delegates objectAtIndex:i];
        if( subscriber != nil && [subscriber respondsToSelector: [ invocation selector ] ] == YES )
        {
            [invocation invokeWithTarget: subscriber];
        }
    }
} 


@end
