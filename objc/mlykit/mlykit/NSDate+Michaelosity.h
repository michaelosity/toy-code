//
//  Michaelosity extensions for NSDate
//  Michael Wells
//  michael@michaelosity.com
//

@interface NSDate (Michaelosity)

-(NSString *)mly_toISO8601String;
+(NSDate *)mly_dateFromISO8601String:(NSString *)string;

@end