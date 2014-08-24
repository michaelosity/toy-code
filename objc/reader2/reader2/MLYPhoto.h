//
//  MLYPhoto
//  Michael Wells
//  michael@michaelosity.com
//

#import <Foundation/Foundation.h>

@interface MLYPhoto : NSObject

@property (nonatomic, readonly) NSURL *imageURL;
@property (nonatomic, readonly) NSURL *profileImageURL;
@property (nonatomic, readonly) NSString *userName;

- (instancetype)initWithDictionary:(NSDictionary *)values;

- (void)loadPhotoImage:(void(^)(UIImage* image))callback;
- (void)loadProfileImage:(void(^)(UIImage* image))callback;

@end