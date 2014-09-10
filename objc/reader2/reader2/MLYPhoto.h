//
//  MLYPhoto
//  Michael Wells
//  michael@michaelosity.com
//

#import <Foundation/Foundation.h>

@interface MLYPhoto : NSObject

@property (nonatomic, readonly) NSURL *imageURL;
@property (nonatomic, readonly) NSString *imageCacheKey;
@property (nonatomic, readonly) NSURL *profileImageURL;
@property (nonatomic, readonly) NSString *profileImageCacheKey;
@property (nonatomic, readonly) NSString *userName;

- (instancetype)initWithDictionary:(NSDictionary *)values;

- (void)downloadImageFromURL:(NSURL*)url forKey:(NSString*)key callback:(void(^)(NSString* key, UIImage* image))callback;

@end