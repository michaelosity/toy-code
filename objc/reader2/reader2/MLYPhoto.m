//
//  MLYPhoto
//  Michael Wells
//  michael@michaelosity.com
//

#import "MLYPhoto.h"
#import "MLYRestClient.h"

@interface MLYPhoto ()

@end

@implementation MLYPhoto

static NSString *cachesFolder;

- (instancetype)initWithDictionary:(NSDictionary *)values
{
    self = [super init];
    if (self)
    {
        NSDictionary *images = values[@"images"];
        NSDictionary *thumbnail = images[@"standard_resolution"];
        NSString *imageURLString = thumbnail[@"url"];
        if ([imageURLString length] > 0)
        {
            _imageURL = [NSURL URLWithString:imageURLString];
        }
        _imageCacheKey = [values[@"id"] copy];

        NSDictionary *user = values[@"user"];
        _userName = [NSString stringWithFormat:@"%@ (%@)", user[@"full_name"], user[@"username"]];
        NSString *profileImageURLString = user[@"profile_picture"];
        if ([profileImageURLString length] > 0)
        {
            _profileImageURL = [NSURL URLWithString:profileImageURLString];
        }
        _profileImageCacheKey = user[@"id"];

        if (!cachesFolder)
        {
            cachesFolder = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        }
    }
    return self;
}

- (void)downloadImageFromURL:(NSURL *)url forKey:(NSString *)key callback:(void(^)(NSString* key, UIImage* image))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^
    {
        UIImage *image = nil;

        NSString *filePath = [cachesFolder stringByAppendingPathComponent:key];

        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            image = [[UIImage alloc] initWithContentsOfFile:filePath];
        }

        if (!image)
        {
            MLYRestClient *client = [[MLYRestClient alloc] initWithURL:url timeout:20.0 username:@"" password:@""];
            MLYRestResponse *response = [client get:@"" progressHandler:nil isResponseJSON:NO headers:nil error:nil];
            if (response.succeeded)
            {
                [(NSData *) response.data writeToFile:filePath atomically:YES];
                image = [[UIImage alloc] initWithData:response.data];
            }
        }

        if (callback)
        {
            callback(key, image);
        }
    });
}


@end