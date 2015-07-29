//
//  Michaelosity extensions for NSDictionary
//  Michael Wells
//  michael@michaelosity.com
//

@interface NSDictionary (Michaelosity)

-(NSString *)mly_safeStringForKey:(id<NSCopying>)key;
-(NSArray *)mly_safeArrayForKey:(id<NSCopying>)key;
-(NSDate *)mly_safeDateForKey:(id<NSCopying>)key;
-(NSDictionary *)mly_safeDictionaryForKey:(id<NSCopying>)key;
-(NSNumber *)mly_safeNumberForKey:(id<NSCopying>)key;

@end