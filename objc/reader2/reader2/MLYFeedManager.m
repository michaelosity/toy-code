//
//  MLYFeedManager
//  Michael Wells
//  michael@michaelosity.com
//

#import "MLYFeedManager.h"
#import "MLYRestClient.h"
#import "MLYPhoto.h"

@interface MLYFeedManager ()

@property (nonatomic, readonly) MLYRestClient *restClient;

@end

@implementation MLYFeedManager

static NSString *kFeedURLString =  @"https://api.instagram.com/v1/media/popular?client_id=50c0e12b64a84dd0b9bbf334ba7f6bf6";

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSURL *url = [NSURL URLWithString:kFeedURLString];
        _restClient = [[MLYRestClient alloc] initWithURL:url timeout:20.0 username:nil password:nil];
    }
    return self;
}

- (void)downloadFeed:(void(^)(NSArray* photos, NSError *error))callback
{
    NSError *error;
    MLYRestResponse *response = [self.restClient get:@""
            progressHandler:nil
            isResponseJSON:YES
            headers:nil
            error:&error];

    if (!response || !response.succeeded)
    {
        callback(nil, error);
        return;
    }

    NSDictionary *json = response.data;

    NSMutableArray *photos = [[NSMutableArray alloc] init];

    for (NSDictionary *item in json[@"data"])
    {
        MLYPhoto *photo = [[MLYPhoto alloc] initWithDictionary:item];
        [photos addObject:photo];
    }

    callback(photos, nil);
}

@end