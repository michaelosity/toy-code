//
// Extensions to NSString
// Michael Wells
// michael@michaelosity.com
//

#import "NSString+Michaelosity.h"

@implementation NSString (Michaelosity)

// Super simple mechanism to strip out inline html elements from an rss feed. I wouldn't use this
// in a production environment, but it's sufficient for here.

-(NSString *)mly_plainText
{
    if ([self length] == 0)
    {
        return @"";
    }

    NSRange r;

    NSString *s = [self copy];

    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    }

    return [s stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
}

@end