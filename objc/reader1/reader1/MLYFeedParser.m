//
// MLYFeedParser
// Michael Wells
// michael@michaelosity.com
//

#import "MLYFeedParser.h"
#import "NSString+Michaelosity.h"
#import "MLYConstants.h"

NSString* const kItemTag = @"item";

@interface MLYFeedParser ()

@property (nonatomic) NSString *filePath;
@property (nonatomic, strong) MLYFeedParserBlock callback;
@property (nonatomic) NSMutableArray *posts;
@property (nonatomic) NSMutableDictionary *accumulators;
@property (nonatomic) NSString *currentElementName;

@end

@implementation MLYFeedParser

- (instancetype)initWithFilePath:(NSString *)filePath callback:(MLYFeedParserBlock)callback
{
    self = [super init];
    if (self)
    {
        _filePath = [filePath copy];
        _callback = callback;
        _posts = [[NSMutableArray alloc] init];
        _accumulators = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)parse
{
    NSData *data = [NSData dataWithContentsOfFile:self.filePath];

    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];

    if (![parser parse])
    {
        NSLog(@"parse error: %@", [[parser parserError] localizedDescription]);
    }
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    [self.posts removeAllObjects];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.accumulators removeAllObjects];

    [self.posts sortUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
        NSDate *d1 = a[MLYPostDateTag];
        NSDate *d2 = b[MLYPostDateTag];

        if ([d1 isEqual:[NSNull null]] || [d2 isEqual:[NSNull null]])
        {
            return NSOrderedSame;
        }

        return [d2 compare:d1];
    }];

    if (self.callback)
    {
        self.callback([self.posts copy]);
    }
}

- (void)parser:(NSXMLParser *)parser
        didStartElement:(NSString *)elementName
        namespaceURI:(NSString *)namespaceURI
        qualifiedName:(NSString *)qName
        attributes:(NSDictionary *)attributeDict
{
    // we really on care about the <item> tag and the <title>, <description>, and <pubDate> tags within that
    if ([elementName isEqualToString:MLYPostTitleTag] || [elementName isEqualToString:MLYPostDescriptionTag] || [elementName isEqualToString:MLYPostDateTag])
    {
        self.currentElementName = elementName;
    }
    else if ([elementName isEqualToString:kItemTag])
    {
        [self.accumulators removeAllObjects];
    }
}

- (void)parser:(NSXMLParser *)parser
        didEndElement:(NSString *)elementName
        namespaceURI:(NSString *)namespaceURI
        qualifiedName:(NSString *)qName
{
    static NSDateFormatter *formatter = nil;
    if (!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    }

    self.currentElementName = nil;
    if ([elementName isEqualToString:kItemTag])
    {
        NSString *title = self.accumulators[MLYPostTitleTag];
        NSString *description = [self.accumulators[MLYPostDescriptionTag] mly_plainText];
        NSDate *date = [formatter dateFromString:self.accumulators[MLYPostDateTag]];
        [self.posts addObject:@{
                MLYPostTitleTag : title ?: NSNull.null, MLYPostDescriptionTag : description ?: NSNull.null, MLYPostDateTag : date ?: NSNull.null}];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.currentElementName)
    {
        NSMutableString *accumulator = self.accumulators[self.currentElementName];
        if (!accumulator)
        {
            accumulator = [[NSMutableString alloc] init];
            self.accumulators[self.currentElementName] = accumulator;
        }
        [accumulator appendString:string];
    }
}

@end