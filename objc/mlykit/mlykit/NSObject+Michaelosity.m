//
//  Michaelosity extensions to NSObject
//  Michael Wells
//  michael@michaelosity.com
//

#import "NSObject+Michaelosity.h"
#import <objc/runtime.h>

@implementation NSObject (Michaelosity)

static char associativeObjectsKey;

-(id)mly_userInfo:(NSString *)key
{
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, &associativeObjectsKey);
    return dictionary[key];
}

-(void)mly_setUserInfo:(id)object forKey:(NSString *)key
{
    if (object)
    {
        NSMutableDictionary *dictionary = objc_getAssociatedObject(self, &associativeObjectsKey);
        if (!dictionary)
        {
            dictionary = [[NSMutableDictionary alloc] init];
            objc_setAssociatedObject(self, &associativeObjectsKey, dictionary, OBJC_ASSOCIATION_RETAIN);
        }
        dictionary[key] = object;
    }
}

@end