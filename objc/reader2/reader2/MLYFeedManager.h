//
//  MLYFeedManager
//  Michael Wells
//  michael@michaelosity.com
//

@interface MLYFeedManager : NSObject

+ (instancetype)sharedInstance;

- (void)downloadFeed:(void(^)(NSArray* photos, NSError *error))callback;

@end