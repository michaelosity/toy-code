//
//  Michaelosity extensions to NSObject
//  Michael Wells
//  michael@michaelosity.com
//

@interface NSObject (Michaelosity)

-(id)mly_userInfo:(NSString *)key;
-(void)mly_setUserInfo:(id)object forKey:(NSString *)key;

@end