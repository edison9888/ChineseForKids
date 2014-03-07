#import "PinyinModel.h"


@interface PinyinModel ()

// Private interface goes here.

@end


@implementation PinyinModel

// Custom logic goes here.
- (void)saveData
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    [localContext saveOnlySelfAndWait];
}

@end
