//
// MLYFeedManager
// Michael Wells
// michael@michaelosity.com
//

#import "MLYFeedManager.h"
#import "MLYConstants.h"

@interface MLYFeedManager ()

@end

@implementation MLYFeedManager

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
        NSString *cachesFolder = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        _filePath = [cachesFolder stringByAppendingPathComponent:@"feed.xml"];
    }
    return self;
}

- (void)download:(void(^)(NSInteger httpStatusCode, NSError *error))callback
{
    NSURL *url = [[NSURL alloc] initWithString:MLYFeedURLString];

    // try to get an etag
    NSString *filePath = [[MLYFeedManager sharedInstance] filePath];
    NSString *etagPath = [filePath stringByAppendingPathExtension:@".etag"];
    NSString *etag = [[NSString alloc] initWithContentsOfFile:etagPath encoding:NSUTF8StringEncoding error:nil];

    // create the session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];

    // create the request and add etag support so we don't redownload the same stuff each time
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    if ([etag length] > 0)
    {
        NSLog(@"found an etag \"%@\"", etag);
        [request setValue:etag forHTTPHeaderField:@"If-None-Match"];
    }

    // and finally the task
    NSLog(@"download the rss feed from \"%@\"", MLYFeedURLString);
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
            {
                if (error)
                {
                    NSLog(@"download failed with error \"%@\"", [error localizedDescription]);
                    if (callback)
                    {
                        callback(-1, error);
                    }
                    return;
                }

                NSInteger statusCode = -1;

                // see if there is an etag
                if ([response isKindOfClass:[NSHTTPURLResponse class]])
                {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

                    statusCode = httpResponse.statusCode;

                    // nothing has changed
                    if (statusCode == 304)
                    {
                        NSLog(@"download returned no new data (status 304)");
                        if (callback)
                        {
                            callback(statusCode, nil);
                        }
                        return;
                    }

                    NSString *etagHeader = [httpResponse allHeaderFields][@"Etag"];

                    NSLog(@"response status code is %d", (int) httpResponse.statusCode);
                    NSLog(@"response headers:\n%@", [[httpResponse allHeaderFields] debugDescription]);
                    NSLog(@"response etag header \"%@\"", etagHeader);

                    NSError *e;
                    [etagHeader writeToFile:etagPath atomically:YES encoding:NSUTF8StringEncoding error:&e];
                    if (e)
                    {
                        NSLog(@"error writing etag \"%@\"", [e localizedDescription]);
                    }
                }

                // write the cache file
                NSLog(@"writing feed data to cache");
                [data writeToFile:filePath atomically:YES];

                // notify so we can update
                NSLog(@"sending notification that ui should be updated");
                [[NSNotificationCenter defaultCenter] postNotificationName:MLYNotifyFeedUpdate object:nil];

                // we got some data
                if (callback)
                {
                    callback(statusCode, nil);
                }
            }];

    // Start the task
    [task resume];
}

@end