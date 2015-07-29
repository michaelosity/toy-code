//
// MLYRestClient
//

#import "MLYRestClient.h"

@interface MLYRestClient ()

@property (nonatomic) double start;
@property (nonatomic) NSURLSession *session;
@property (nonatomic) long long sessionIdentifier;
@property (nonatomic) NSString *urlPrefix;
@property (nonatomic) NSURLCredential *credential;
@property (nonatomic) NSMutableDictionary *semaphores;
@property (nonatomic) NSMutableDictionary *receivedAccumulators;
@property (nonatomic) NSMutableDictionary *sentAccumulators;
@property (nonatomic) NSMutableDictionary *progressHandlers;

@end

@implementation MLYRestClient

static NSString *kBIRestClientDomain = @"MLYRestClient";

+ (void)p_addHeaders:(NSDictionary *)headers toRequest:(NSMutableURLRequest *)request
{
    if (headers)
    {
        for (NSString *field in headers.allKeys)
        {
            [request setValue:headers[field] forHTTPHeaderField:field];
        }
    }
}

#pragma mark - Initializer

- (instancetype)initWithURL:(NSURL *)url
        timeout:(NSTimeInterval)timeout
        username:(NSString *)username
        password:(NSString *)password
{
    self = [super init];

    if (self)
    {
        static unsigned int nextSessionId = 0;

        _semaphores = [[NSMutableDictionary alloc] init];
        _sentAccumulators = [[NSMutableDictionary alloc] init];
        _receivedAccumulators = [[NSMutableDictionary alloc] init];
        _progressHandlers = [[NSMutableDictionary alloc] init];

        _sessionIdentifier = nextSessionId++;

        _urlPrefix = [[url description] copy];

        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];

        if (timeout > 0)
        {
            config.timeoutIntervalForRequest = timeout;
        }

        if (username && password)
        {
            _credential = [NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistenceForSession];
        }

        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }

    return self;
}

#pragma mark - API

- (MLYRestResponse *)delete:(NSString *)path
        progressHandler:(MLYRestClientProgressBlock)progressHandler
        isResponseJSON:(BOOL)isResponseJSON
        headers:(NSDictionary *)headers
        error:(NSError **)error
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.urlPrefix, path]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    request.HTTPMethod = @"DELETE";

    [MLYRestClient p_addHeaders:headers toRequest:request];

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];

    return [self p_execute:task progressHandler:progressHandler isResponseJSON:isResponseJSON error:error];
}

- (MLYRestResponse *)get:(NSString *)path
        progressHandler:(MLYRestClientProgressBlock)progressHandler
        isResponseJSON:(BOOL)isResponseJSON
        headers:(NSDictionary *)headers
        error:(NSError **)error
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.urlPrefix, path]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    request.HTTPMethod = @"GET";

    [MLYRestClient p_addHeaders:headers toRequest:request];

    if (progressHandler)
    {
        return [self p_execute:[self.session downloadTaskWithRequest:request] progressHandler:progressHandler isResponseJSON:isResponseJSON error:error];
    }
    else
    {
        return [self p_execute:[self.session dataTaskWithRequest:request] progressHandler:nil isResponseJSON:isResponseJSON error:error];
    }
}

- (MLYRestResponse *)post:(NSString *)path
        body:(id)body
        progressHandler:(MLYRestClientProgressBlock)progressHandler
        isResponseJSON:(BOOL)isResponseJSON
        headers:(NSDictionary *)headers
        error:(NSError **)error
{
    return [self p_putOrPost:path
            method:@"POST"
            body:body
            progressHandler:progressHandler
            isResponseJSON:isResponseJSON
            headers:headers
            error:error];
}

- (MLYRestResponse *)postFile:(NSString *)path
        filePath:(NSString *)filePath
        progressHandler:(MLYRestClientProgressBlock)progressHandler
        isResponseJSON:(BOOL)isResponseJSON
        headers:(NSDictionary *)headers
        error:(NSError **)error
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.urlPrefix, path]];

    NSURL *fileURL = [NSURL fileURLWithPath:filePath];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    request.HTTPMethod = @"POST";

    [MLYRestClient p_addHeaders:headers toRequest:request];

    NSURLSessionUploadTask *task = [self.session uploadTaskWithRequest:request fromFile:fileURL];

    return [self p_execute:task progressHandler:progressHandler isResponseJSON:isResponseJSON error:error];
}

- (MLYRestResponse *)put:(NSString *)path
        body:(id)body
        progressHandler:(MLYRestClientProgressBlock)progressHandler
        isResponseJSON:(BOOL)isResponseJSON
        headers:(NSDictionary *)headers
        error:(NSError **)error
{
    return [self p_putOrPost:path
            method:@"PUT"
            body:body
            progressHandler:progressHandler
            isResponseJSON:isResponseJSON
            headers:headers
            error:error];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
        didBecomeInvalidWithError:(NSError *)error
{
    NSLog(@"ERROR: rest client [%lld:*] session became invalid: %@", self.sessionIdentifier, [error localizedDescription]);
}

- (void)URLSession:(NSURLSession *)session
        didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
        completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    if (challenge.previousFailureCount == 0)
    {
        completionHandler(NSURLSessionAuthChallengeUseCredential, self.credential);
    }
    else
    {
        NSLog(@"rest client [%lld:*] session authentication challenge canceled (%ld previous attempts)", self.sessionIdentifier, (long) challenge.previousFailureCount);
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
        task:(NSURLSessionTask *)task
        didCompleteWithError:(NSError *)error
{
    dispatch_semaphore_t semaphore = self.semaphores[@(task.taskIdentifier)];

    if (semaphore)
    {
        dispatch_semaphore_signal(semaphore);
    }
}

- (void)URLSession:(NSURLSession *)session
        task:(NSURLSessionTask *)task
        didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
        completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    if (challenge.previousFailureCount == 0)
    {
        completionHandler(NSURLSessionAuthChallengeUseCredential, self.credential);
    }
    else
    {
        NSLog(@"rest client [%lld:%ld] task authentication challenge canceled (%ld previous attempts)", self.sessionIdentifier, (unsigned long) task.taskIdentifier, (long) challenge.previousFailureCount);
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)URLSession:(NSURLSession *)session
        task:(NSURLSessionTask *)task
        didSendBodyData:(int64_t)bytesSent
        totalBytesSent:(int64_t)totalBytesSent
        totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    MLYRestClientProgressBlock progressHandler = self.progressHandlers[@(task.taskIdentifier)];

    self.sentAccumulators[@(task.taskIdentifier)] = @(totalBytesSent);

    if (totalBytesExpectedToSend == NSURLSessionTransferSizeUnknown)
    {
        NSLog(@"rest client [%lld:%ld] uploaded %1.2f MB of unknown MB",
            self.sessionIdentifier,
            (unsigned long) task.taskIdentifier,
            totalBytesSent / (1024 * 1024.0));

        if (progressHandler)
        {
            progressHandler(@(totalBytesSent), @(totalBytesExpectedToSend), @(-1.0f));
        }
    }
    else
    {
        float progress = (long) totalBytesSent / (float) totalBytesExpectedToSend;

        double time = CFAbsoluteTimeGetCurrent() - self.start;

        double bandwidth = totalBytesSent * 8 / time / 1000000;

        NSLog(@"rest client [%lld:%ld] uploaded %1.2f MB of %1.2f MB (%d%% @ %1.2f Mbps)",
            self.sessionIdentifier,
            (unsigned long) task.taskIdentifier,
            totalBytesSent / (1024 * 1024.0),
            totalBytesExpectedToSend / (1024 * 1024.0),
            (int) (progress * 100.0),
            bandwidth);

        if (progressHandler)
        {
            progressHandler(@(totalBytesSent), @(totalBytesExpectedToSend), @(progress));
        }
    }
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
        dataTask:(NSURLSessionDataTask *)dataTask
        didReceiveResponse:(NSURLResponse *)response
        completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    if (completionHandler)
    {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session
        dataTask:(NSURLSessionDataTask *)dataTask
        didReceiveData:(NSData *)data
{
    NSMutableData *accumulator = self.receivedAccumulators[@(dataTask.taskIdentifier)];

    if (accumulator)
    {
        [accumulator appendData:data];
    }
}

- (void)URLSession:(NSURLSession *)session
        dataTask:(NSURLSessionDataTask *)dataTask
        willCacheResponse:(NSCachedURLResponse *)proposedResponse
        completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    if (completionHandler)
    {
        completionHandler(NULL); // don't cache
    }
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
        downloadTask:(NSURLSessionDownloadTask *)downloadTask
        didResumeAtOffset:(int64_t)fileOffset
        expectedTotalBytes:(int64_t)expectedTotalBytes
{
}

- (void)URLSession:(NSURLSession *)session
        downloadTask:(NSURLSessionDownloadTask *)downloadTask
        didWriteData:(int64_t)bytesWritten
        totalBytesWritten:(int64_t)totalBytesWritten
        totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    MLYRestClientProgressBlock progressHandler = self.progressHandlers[@(downloadTask.taskIdentifier)];

    if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown)
    {
        NSLog(@"rest client [%lld:%ld] downloaded %1.2f MB of unknown MB",
        self.sessionIdentifier,
        (unsigned long) downloadTask.taskIdentifier,
        totalBytesWritten / (1024 * 1024.0));

        if (progressHandler)
        {
            progressHandler(@(totalBytesWritten), @(totalBytesExpectedToWrite), @(-1.0f));
        }
    }
    else
    {
        float progress = (long) totalBytesWritten / (float) totalBytesExpectedToWrite;

        if (progressHandler)
        {
            progressHandler(@(totalBytesWritten), @(totalBytesExpectedToWrite), @(progress));
        }

        double time = CFAbsoluteTimeGetCurrent() - self.start;

        double bandwidth = totalBytesWritten * 8 / time / 1000000;

        NSLog(@"rest client [%lld:%ld] downloaded %1.2f MB of %1.2f MB (%d%% @ %1.2f Mbs)",
            self.sessionIdentifier,
            (unsigned long) downloadTask.taskIdentifier,
            totalBytesWritten / (1024 * 1024.0),
            totalBytesExpectedToWrite / (1024 * 1024.0),
            (int) (progress * 100.0),
            bandwidth);
    }
}

- (void)URLSession:(NSURLSession *)session
        downloadTask:(NSURLSessionDownloadTask *)downloadTask
        didFinishDownloadingToURL:(NSURL *)location
{
    NSMutableData *accumulator = self.receivedAccumulators[@(downloadTask.taskIdentifier)];

    if (accumulator)
    {
        [accumulator appendData:[NSData dataWithContentsOfURL:location]];
    }
}

#pragma mark - Internal

- (MLYRestResponse *)p_execute:(NSURLSessionTask *)task
        progressHandler:(MLYRestClientProgressBlock)progressHandler
        isResponseJSON:(BOOL)isResponseJSON
        error:(NSError **)error
{
    self.start = CFAbsoluteTimeGetCurrent();

    NSURLRequest *request = task.originalRequest;

    NSLog(@"rest client [%lld:%ld] %@ %@ --->", self.sessionIdentifier, (unsigned long) task.taskIdentifier, request.HTTPMethod, request.URL);

    NSNumber *identifier = @(task.taskIdentifier);

    self.sentAccumulators[identifier] = @0;
    self.receivedAccumulators[identifier] = [[NSMutableData alloc] init];

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    self.semaphores[identifier] = semaphore;

    if (progressHandler)
    {
        self.progressHandlers[identifier] = progressHandler;
    }

    [task resume];

    // todo: we really shouldn't be doing synchronous calls like this
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    NSData *dataReceived = self.receivedAccumulators[identifier];

    [self.semaphores removeObjectForKey:identifier];
    [self.progressHandlers removeObjectForKey:identifier];

    [self.receivedAccumulators removeObjectForKey:identifier];
    [self.sentAccumulators removeObjectForKey:identifier];

    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *) task.response;

    double time = CFAbsoluteTimeGetCurrent() - self.start;

    if (urlResponse)
    {
        if (task.error)
        {
            if (time < 1.0f)
            {
                NSLog(@"rest client [%lld:%ld] %@ %@ (sent %1.1f KB received %1.1f KB @ %1.2f Mbps) <--- %ld (%d ms): %@",
                    self.sessionIdentifier,
                    (unsigned long) task.taskIdentifier,
                    request.HTTPMethod,
                    request.URL,
                    task.countOfBytesSent / 1024.0,
                    task.countOfBytesReceived / 1024.0,
                    (task.countOfBytesSent + task.countOfBytesReceived) * 8 / time / 1000000,
                    (long) urlResponse.statusCode,
                    (int) ceil(time * 1000.0),
                    [task.error localizedDescription]);
            }
            else
            {
                NSLog(@"rest client [%lld:%ld] %@ %@ (sent %1.1f KB received %1.1f KB @ %1.2f Mbps) <--- %ld (%1.2f s): %@",
                    self.sessionIdentifier,
                    (unsigned long) task.taskIdentifier,
                    request.HTTPMethod,
                    request.URL,
                    task.countOfBytesSent / 1024.0,
                    task.countOfBytesReceived / 1024.0,
                    (task.countOfBytesSent + task.countOfBytesReceived) * 8 / time / 1000000,
                    (long) urlResponse.statusCode,
                    time,
                    [task.error localizedDescription]);
            }
        }
        else
        {
            if (time < 1.0f)
            {
                NSLog(@"rest client [%lld:%ld] %@ %@ (sent %1.1f KB received %1.1f KB @ %1.2f Mbps) <--- %ld (%d ms)",
                    self.sessionIdentifier,
                    (unsigned long) task.taskIdentifier,
                    request.HTTPMethod,
                    request.URL,
                    task.countOfBytesSent / 1024.0,
                    task.countOfBytesReceived / 1024.0,
                    (task.countOfBytesSent + task.countOfBytesReceived) * 8 / time / 1000000,
                    (long) urlResponse.statusCode,
                    (int) ceil(time * 1000.0));
            }
            else
            {
                NSLog(@"rest client [%lld:%lud] %@ %@ (sent %1.1f KB received %1.1f KB @ %1.2f Mbps) <--- %ld (%1.2f s)",
                    self.sessionIdentifier,
                    (unsigned long) task.taskIdentifier,
                    request.HTTPMethod,
                    request.URL,
                    task.countOfBytesSent / 1024.0,
                    task.countOfBytesReceived / 1024.0,
                    (task.countOfBytesSent + task.countOfBytesReceived) * 8 / time / 1000000,
                    (long) urlResponse.statusCode,
                    time);
            }
        }
    }

    id data = dataReceived;

    NSError *responseError = nil;

    if (task.error)
    {
        responseError = task.error;

        if (error)
        {
            *error = task.error;
        }
    }
    else if (urlResponse.statusCode != 200 &&
            urlResponse.statusCode != 201 &&
            urlResponse.statusCode != 204 &&
            urlResponse.statusCode != 304)
    {
        responseError = [NSError errorWithDomain:kBIRestClientDomain code:urlResponse.statusCode userInfo:@{
                NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Error (%ld)", (long) urlResponse.statusCode],
                NSLocalizedFailureReasonErrorKey : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]
        }];

        if (error)
        {
            *error = responseError;
        }
    }
    else if (isResponseJSON)
    {
        if (urlResponse.statusCode != 204)
        {
            id jsonData = [NSJSONSerialization JSONObjectWithData:dataReceived options:0ul error:&responseError];

            if (jsonData)
            {
                data = jsonData;
            }
            else
            {
                NSLog(@"ERROR: rest client [%lld:%ld] %@ %@ error deserializing json: %@",
                    self.sessionIdentifier,
                    (unsigned long) task.taskIdentifier,
                    request.HTTPMethod,
                    request.URL,
                    responseError);

                if (error)
                {
                    *error = responseError;
                }
            }
        }
    }

    return [[MLYRestResponse alloc] initWithData:data
            statusCode:urlResponse.statusCode
            headers:urlResponse.allHeaderFields
            error:responseError];
}

- (MLYRestResponse *)p_putOrPost:(NSString *)path
        method:(NSString *)method
        body:(id)body
        progressHandler:(MLYRestClientProgressBlock)progressHandler
        isResponseJSON:(BOOL)isResponseJSON
        headers:(NSDictionary *)headers
        error:(NSError **)error
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.urlPrefix, path]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    request.HTTPMethod = method;

    [MLYRestClient p_addHeaders:headers toRequest:request];

    NSData *bodyData;

    NSURLSessionTask *task;

    if (!body)
    {
        task = [self.session dataTaskWithRequest:request];
    }
    else
    {
        NSError *jsonError;

        bodyData = [NSJSONSerialization dataWithJSONObject:body options:0ul error:&jsonError];

        if (!bodyData && jsonError)
        {
            NSLog(@"ERROR: rest client POST %@ error serializing body to json: %@", url, jsonError);

            if (error)
            {
                *error = jsonError;
            }

            return [[MLYRestResponse alloc] initWithData:nil statusCode:0 headers:nil error:jsonError];
        }

        [request setValue:@"text/x-json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long) bodyData.length] forHTTPHeaderField:@"Content-Length"];

        task = [self.session uploadTaskWithRequest:request fromData:bodyData];
    }

    return [self p_execute:task progressHandler:progressHandler isResponseJSON:isResponseJSON error:error];
}

@end
