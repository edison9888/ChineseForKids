#import "GroupModel.h"


@interface GroupModel ()

// Private interface goes here.

@end


@implementation GroupModel

// Custom logic goes here.
- (void)saveData
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    [localContext saveOnlySelfAndWait];
}

@end
