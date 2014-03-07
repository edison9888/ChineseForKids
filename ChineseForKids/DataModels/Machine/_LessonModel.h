// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LessonModel.h instead.

#import <CoreData/CoreData.h>


extern const struct LessonModelAttributes {
	__unsafe_unretained NSString *bookID;
	__unsafe_unretained NSString *dataVersion;
	__unsafe_unretained NSString *lessonID;
	__unsafe_unretained NSString *lessonIndex;
	__unsafe_unretained NSString *lessonName;
	__unsafe_unretained NSString *locked;
	__unsafe_unretained NSString *progress;
	__unsafe_unretained NSString *score;
	__unsafe_unretained NSString *starAmount;
	__unsafe_unretained NSString *typeID;
	__unsafe_unretained NSString *updateTime;
	__unsafe_unretained NSString *userID;
} LessonModelAttributes;

extern const struct LessonModelRelationships {
} LessonModelRelationships;

extern const struct LessonModelFetchedProperties {
} LessonModelFetchedProperties;















@interface LessonModelID : NSManagedObjectID {}
@end

@interface _LessonModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LessonModelID*)objectID;





@property (nonatomic, strong) NSNumber* bookID;



@property int32_t bookIDValue;
- (int32_t)bookIDValue;
- (void)setBookIDValue:(int32_t)value_;

//- (BOOL)validateBookID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* dataVersion;



@property float dataVersionValue;
- (float)dataVersionValue;
- (void)setDataVersionValue:(float)value_;

//- (BOOL)validateDataVersion:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lessonID;



@property int32_t lessonIDValue;
- (int32_t)lessonIDValue;
- (void)setLessonIDValue:(int32_t)value_;

//- (BOOL)validateLessonID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lessonIndex;



@property float lessonIndexValue;
- (float)lessonIndexValue;
- (void)setLessonIndexValue:(float)value_;

//- (BOOL)validateLessonIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lessonName;



//- (BOOL)validateLessonName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* locked;



@property BOOL lockedValue;
- (BOOL)lockedValue;
- (void)setLockedValue:(BOOL)value_;

//- (BOOL)validateLocked:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* progress;



@property float progressValue;
- (float)progressValue;
- (void)setProgressValue:(float)value_;

//- (BOOL)validateProgress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* score;



@property int32_t scoreValue;
- (int32_t)scoreValue;
- (void)setScoreValue:(int32_t)value_;

//- (BOOL)validateScore:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* starAmount;



@property int32_t starAmountValue;
- (int32_t)starAmountValue;
- (void)setStarAmountValue:(int32_t)value_;

//- (BOOL)validateStarAmount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* typeID;



@property int32_t typeIDValue;
- (int32_t)typeIDValue;
- (void)setTypeIDValue:(int32_t)value_;

//- (BOOL)validateTypeID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* updateTime;



//- (BOOL)validateUpdateTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* userID;



//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;






@end

@interface _LessonModel (CoreDataGeneratedAccessors)

@end

@interface _LessonModel (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveBookID;
- (void)setPrimitiveBookID:(NSNumber*)value;

- (int32_t)primitiveBookIDValue;
- (void)setPrimitiveBookIDValue:(int32_t)value_;




- (NSNumber*)primitiveDataVersion;
- (void)setPrimitiveDataVersion:(NSNumber*)value;

- (float)primitiveDataVersionValue;
- (void)setPrimitiveDataVersionValue:(float)value_;




- (NSNumber*)primitiveLessonID;
- (void)setPrimitiveLessonID:(NSNumber*)value;

- (int32_t)primitiveLessonIDValue;
- (void)setPrimitiveLessonIDValue:(int32_t)value_;




- (NSNumber*)primitiveLessonIndex;
- (void)setPrimitiveLessonIndex:(NSNumber*)value;

- (float)primitiveLessonIndexValue;
- (void)setPrimitiveLessonIndexValue:(float)value_;




- (NSString*)primitiveLessonName;
- (void)setPrimitiveLessonName:(NSString*)value;




- (NSNumber*)primitiveLocked;
- (void)setPrimitiveLocked:(NSNumber*)value;

- (BOOL)primitiveLockedValue;
- (void)setPrimitiveLockedValue:(BOOL)value_;




- (NSNumber*)primitiveProgress;
- (void)setPrimitiveProgress:(NSNumber*)value;

- (float)primitiveProgressValue;
- (void)setPrimitiveProgressValue:(float)value_;




- (NSNumber*)primitiveScore;
- (void)setPrimitiveScore:(NSNumber*)value;

- (int32_t)primitiveScoreValue;
- (void)setPrimitiveScoreValue:(int32_t)value_;




- (NSNumber*)primitiveStarAmount;
- (void)setPrimitiveStarAmount:(NSNumber*)value;

- (int32_t)primitiveStarAmountValue;
- (void)setPrimitiveStarAmountValue:(int32_t)value_;




- (NSNumber*)primitiveTypeID;
- (void)setPrimitiveTypeID:(NSNumber*)value;

- (int32_t)primitiveTypeIDValue;
- (void)setPrimitiveTypeIDValue:(int32_t)value_;




- (NSString*)primitiveUpdateTime;
- (void)setPrimitiveUpdateTime:(NSString*)value;




- (NSString*)primitiveUserID;
- (void)setPrimitiveUserID:(NSString*)value;




@end
