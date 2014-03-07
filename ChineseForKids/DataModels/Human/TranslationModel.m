#import "TranslationModel.h"


@interface TranslationModel ()

// Private interface goes here.

@end


@implementation TranslationModel

// Custom logic goes here.
- (void)saveData
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    [localContext saveOnlySelfAndWait];
}

@end
