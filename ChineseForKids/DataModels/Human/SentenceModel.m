#import "SentenceModel.h"


@interface SentenceModel ()

// Private interface goes here.

@end


@implementation SentenceModel

// Custom logic goes here.
- (void)saveData
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    [localContext saveOnlySelfAndWait];
}

@end
