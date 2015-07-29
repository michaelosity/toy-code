//
//  Michaelosity extensions to NSString
//  Michael Wells
//  michael@michaelosity.com
//

@interface NSString (Michaelosity)

+ (NSString *)mly_createGuid;
+ (NSString *)mly_emptyGuid;

- (NSString *)mly_md5Hash;
- (NSString *)mly_sha1Hash;
- (NSString *)mly_sha256Hash;
- (NSString *)mly_sha512Hash;

@end