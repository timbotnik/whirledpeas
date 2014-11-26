//
//  MinMaxRange.h
//  Code Samples
//
//  Created by Tim Hingston on 3/24/14.
//  Copyright (c) 2014 Tim Hingston. All rights reserved.
//

#ifndef Form_MinMaxRange_h
#define Form_MinMaxRange_h

#import <UIKit/UIKit.h>

#define MinMaxRangeNull MinMaxRangeMake(-1, -1)

struct MinMaxRange
{
    CGFloat min;
    CGFloat max;
};
typedef struct MinMaxRange MinMaxRange;

NS_INLINE MinMaxRange MinMaxRangeMake(CGFloat min, CGFloat max)
{
    MinMaxRange range;
    range.min = min;
    range.max = max;
    return range;
}

NS_INLINE BOOL MinMaxRangeIsNull(MinMaxRange range)
{
    return range.min == MinMaxRangeNull.min && range.max == MinMaxRangeNull.max;
}

#endif
