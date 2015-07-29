//
//  Michaelosity extensions to NSString
//  Michael Wells
//  michael@michaelosity.com
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+Michaelosity.h"

@implementation NSString (Michaelosity)

+ (NSString *)mly_createGuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);

    NSString *uuidString = (__bridge_transfer NSString *) CFUUIDCreateString(kCFAllocatorDefault, uuidRef);

    CFRelease(uuidRef);

    return [uuidString lowercaseString];
}

+ (NSString *)mly_emptyGuid
{
    return @"00000000-0000-0000-0000-000000000000";
}

- (NSString *)mly_md5Hash
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_MD5_DIGEST_LENGTH];

    CC_MD5(data.bytes, (unsigned int) data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (NSString *)mly_sha1Hash
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (unsigned int) data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (NSString *)mly_sha256Hash
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];

    CC_SHA256(data.bytes, (unsigned int) data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (NSString *)mly_sha512Hash
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];

    CC_SHA512(data.bytes, (unsigned int) data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

@end