//
//  MLYRestClient
//  Michael Wells
//  michael@michaelosity.com
//

#import "MLYRestResponse.h"

typedef void (^MLYRestClientProgressBlock)(NSNumber *bytesProcessedSoFar, NSNumber *bytesExpectedToProcess, NSNumber *progress);

@interface MLYRestClient : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

- (instancetype)initWithURL:(NSURL *)url
        timeout:(NSTimeInterval)timeout
        username:(NSString *)username
        password:(NSString *)password;

- (MLYRestResponse *)get:(NSString *)path
        progressHandler:(MLYRestClientProgressBlock)progressHandler
        isResponseJSON:(BOOL)isResponseJSON
        headers:(NSDictionary *)headers
        error:(NSError **)error;

- (MLYRestResponse *)post:(NSString *)path
        body:(id)body
        progressHandler:(MLYRestClientProgressBlock)progressHandler
        isResponseJSON:(BOOL)isResponseJSON
        headers:(NSDictionary *)headers
        error:(NSError **)error;

- (MLYRestResponse *)delete:(NSString *)path
        progressHandler:(MLYRestClientProgressBlock)progressHandler
        isResponseJSON:(BOOL)isResponseJSON
        headers:(NSDictionary *)headers
        error:(NSError **)error;

- (MLYRestResponse *)postFile:(NSString *)path
        filePath:(NSString *)filePath
        progressHandler:(MLYRestClientProgressBlock)progressHandler
        isResponseJSON:(BOOL)isResponseJSON
        headers:(NSDictionary *)headers
        error:(NSError **)error;

- (MLYRestResponse *)put:(NSString *)path
        body:(id)body
        progressHandler:(MLYRestClientProgressBlock)progressHandler
        isResponseJSON:(BOOL)isResponseJSON
        headers:(NSDictionary *)headers
        error:(NSError **)error;

@end
