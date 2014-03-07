#import "LessonModel.h"
#import "DMDataManager.h"

@interface LessonModel ()

// Private interface goes here.

@end


@implementation LessonModel

// Custom logic goes here.

- (void)saveData
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    [localContext saveOnlySelfAndWait];
}

@end
