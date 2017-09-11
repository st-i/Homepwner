//
//  BNRImageTransformer.m
//  Homepwner
//
//  Created by iStef on 15.01.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "BNRImageTransformer.h"

@implementation BNRImageTransformer

+(Class)transformedValueClass
{
    return [NSData class];
}

-(id)transformedValue:(id)value
{
    if (!value) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

-(id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end
