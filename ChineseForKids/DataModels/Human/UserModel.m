#import "UserModel.h"


@interface UserModel ()

// Private interface goes here.

@end


@implementation UserModel

// Custom logic goes here.
- (void)saveData
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    [localContext saveOnlySelfAndWait];
}

@end
