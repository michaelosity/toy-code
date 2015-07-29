//
//  MLYRestResponse
//  Michael Wells
//  michael@michaelosity.com
//

@interface MLYRestResponse : NSObject

@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, readonly) NSDictionary *headers;
@property (nonatomic, readonly) NSError* error;
@property (nonatomic, readonly) BOOL succeeded;

-(id)initWithData:(id)data statusCode:(NSInteger)statusCode headers:(NSDictionary *)headers error:(NSError *)error;

@end