#import "BookModel.h"


@interface BookModel ()

// Private interface goes here.

@end


@implementation BookModel

// Custom logic goes here.
- (void)saveData
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    [localContext saveOnlySelfAndWait];
}

@end
