//
// MLYFeedParser
// Michael Wells
// michael@michaelosity.com
//

#import <Foundation/Foundation.h>

typedef void (^MLYFeedParserBlock)(NSArray *posts);

@interface MLYFeedParser : NSObject <NSXMLParserDelegate>

- (instancetype)initWithFilePath:(NSString *)filePath callback:(MLYFeedParserBlock)callback;

- (void)parse;

@end