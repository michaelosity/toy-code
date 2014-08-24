//
//  MLYRestResponse
//  Michael Wells
//  michael@michaelosity.com
//

#import "MLYRestResponse.h"

@implementation MLYRestResponse

-(id)initWithData:(id)data statusCode:(NSInteger)statusCode headers:(NSDictionary *)headers error:(NSError *)error
{
    self = [super init];

    if (self)
    {
        _data = data;
        _statusCode = statusCode;
        _headers = headers;
        _error = error;
        _succeeded = statusCode == 200 || statusCode == 201 || statusCode == 204 || statusCode == 304;
    }

    return self;
}

@end