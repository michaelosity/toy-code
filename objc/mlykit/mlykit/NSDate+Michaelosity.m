//
//  Michaelosity extensions for NSDate
//  Michael Wells
//  michael@michaelosity.com
//

#import "NSDate+Michaelosity.h"

@implementation NSDate (Michaelosity)

static NSString *kISO8601Format = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

-(NSString *)mly_toISO8601String
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:kISO8601Format];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    return [dateFormatter stringFromDate:self];
}

+(NSDate *)mly_dateFromISO8601String:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kISO8601Format];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    return [formatter dateFromString:string];
}

@end