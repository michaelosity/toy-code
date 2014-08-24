//
// MLYAppDelegate.m
// Michael Wells
// michael@michaelosity.com
//

#import "MLYAppDelegate.h"
#import "MLYFeedManager.h"

@interface MLYAppDelegate ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MLYAppDelegate

static const double kUpdateInterval = 60 * 10.0; // 10 minutes

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setMinimumBackgroundFetchInterval:kUpdateInterval];

    // No need to queue up a download if we're being launched in the background; that is handled
    // in application:performFetchWithCompletionHandler below.
    if (application.applicationState == UIApplicationStateBackground)
    {
        NSLog(@"background startup does not queue an automtic download");
    }
    else
    {
        NSLog(@"normal startup queues a download of posts, we'll set a timer going in applicationDidBecomeActive");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
            [[MLYFeedManager sharedInstance] download:nil];
        });
    }

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive");
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    if (!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kUpdateInterval
                target:self
                selector:@selector(timerFired:)
                userInfo:nil
                repeats:YES];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate");
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"performFetchWithCompletionHandler");
    [[MLYFeedManager sharedInstance] download:^(NSInteger httpStatusCode, NSError *error) {
        if (completionHandler)
        {
            if (error)
            {
                completionHandler(UIBackgroundFetchResultFailed);
            }
            else if (httpStatusCode == 304)
            {
                completionHandler(UIBackgroundFetchResultNoData);
            }
            else
            {
                completionHandler(UIBackgroundFetchResultNewData);
            }
        }
    }];
}

- (void)timerFired:(NSTimer *)timer
{
    if ([timer isValid])
    {
        [[MLYFeedManager sharedInstance] download:nil];
    }
}

@end
