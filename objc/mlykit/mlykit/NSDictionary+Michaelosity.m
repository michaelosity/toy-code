//
//  Michaelosity extensions for NSDictionary
//  Michael Wells
//  michael@michaelosity.com
//

#import "NSDictionary+Michaelosity.h"

@implementation NSDictionary (Michaelosity)

-(NSString *)mly_safeStringForKey:(id<NSCopying>)key
{
    return [self p_safeValueForKey:key class:[NSString class]];
}

-(NSArray *)mly_safeArrayForKey:(id<NSCopying>)key
{
    return [self p_safeValueForKey:key class:[NSArray class]];
}

-(NSDate *)mly_safeDateForKey:(id<NSCopying>)key
{
    return [self p_safeValueForKey:key class:[NSDate class]];
}

-(NSDictionary *)mly_safeDictionaryForKey:(id<NSCopying>)key
{
    return [self p_safeValueForKey:key class:[NSDictionary class]];
}

-(NSNumber *)mly_safeNumberForKey:(id<NSCopying>)key
{
    return [self p_safeValueForKey:key class:[NSNumber class]];
}

-(id)p_safeValueForKey:(id <NSCopying>)key class:(Class)class
{
    id value = self[key];

    if (value && ![value isEqual:[NSNull null]] && [value isKindOfClass:class])
    {
        return value;
    }

    return nil;
}

@end