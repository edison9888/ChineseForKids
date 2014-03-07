#import "WordModel.h"


@interface WordModel ()

// Private interface goes here.

@end


@implementation WordModel

// Custom logic goes here.
- (void)saveData
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    [localContext saveOnlySelfAndWait];
}

@end
