#import "SentencePatternModel.h"


@interface SentencePatternModel ()

// Private interface goes here.

@end


@implementation SentencePatternModel

// Custom logic goes here.
- (void)saveData
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    [localContext saveOnlySelfAndWait];
}

@end
