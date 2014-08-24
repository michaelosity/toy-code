//
// MLYFeedManager
// Michael Wells
// michael@michaelosity.com
//

@interface MLYFeedManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) NSString *filePath;

- (void)download:(void(^)(NSInteger httpStatusCode, NSError *error))callback;

@end