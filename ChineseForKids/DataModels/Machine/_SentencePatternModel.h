// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SentencePatternModel.h instead.

#import <CoreData/CoreData.h>


extern const struct SentencePatternModelAttributes {
	__unsafe_unretained NSString *english;
	__unsafe_unretained NSString *knowledgeID;
	__unsafe_unretained NSString *lessonID;
	__unsafe_unretained NSString *progress;
	__unsafe_unretained NSString *rightTimes;
	__unsafe_unretained NSString *sentencePattern;
	__unsafe_unretained NSString *typeID;
	__unsafe_unretained NSString *userID;
	__unsafe_unretained NSString *wrongTimes;
} SentencePatternModelAttributes;

extern const struct SentencePatternModelRelationships {
} SentencePatternModelRelationships;

extern const struct SentencePatternModelFetchedProperties {
} SentencePatternModelFetchedProperties;












@interface SentencePatternModelID : NSManagedObjectID {}
@end

@interface _SentencePatternModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SentencePatternModelID*)objectID;





@property (nonatomic, strong) NSString* english;



//- (BOOL)validateEnglish:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* knowledgeID;



@property int32_t knowledgeIDValue;
- (int32_t)knowledgeIDValue;
- (void)setKnowledgeIDValue:(int32_t)value_;

//- (BOOL)validateKnowledgeID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lessonID;



@property int32_t lessonIDValue;
- (int32_t)lessonIDValue;
- (void)setLessonIDValue:(int32_t)value_;

//- (BOOL)validateLessonID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* progress;



@property float progressValue;
- (float)progressValue;
- (void)setProgressValue:(float)value_;

//- (BOOL)validateProgress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* rightTimes;



@property int32_t rightTimesValue;
- (int32_t)rightTimesValue;
- (void)setRightTimesValue:(int32_t)value_;

//- (BOOL)validateRightTimes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sentencePattern;



//- (BOOL)validateSentencePattern:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* typeID;



@property int32_t typeIDValue;
- (int32_t)typeIDValue;
- (void)setTypeIDValue:(int32_t)value_;

//- (BOOL)validateTypeID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* userID;



//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* wrongTimes;



@property int32_t wrongTimesValue;
- (int32_t)wrongTimesValue;
- (void)setWrongTimesValue:(int32_t)value_;

//- (BOOL)validateWrongTimes:(id*)value_ error:(NSError**)error_;






@end

@interface _SentencePatternModel (CoreDataGeneratedAccessors)

@end

@interface _SentencePatternModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveEnglish;
- (void)setPrimitiveEnglish:(NSString*)value;




- (NSNumber*)primitiveKnowledgeID;
- (void)setPrimitiveKnowledgeID:(NSNumber*)value;

- (int32_t)primitiveKnowledgeIDValue;
- (void)setPrimitiveKnowledgeIDValue:(int32_t)value_;




- (NSNumber*)primitiveLessonID;
- (void)setPrimitiveLessonID:(NSNumber*)value;

- (int32_t)primitiveLessonIDValue;
- (void)setPrimitiveLessonIDValue:(int32_t)value_;




- (NSNumber*)primitiveProgress;
- (void)setPrimitiveProgress:(NSNumber*)value;

- (float)primitiveProgressValue;
- (void)setPrimitiveProgressValue:(float)value_;




- (NSNumber*)primitiveRightTimes;
- (void)setPrimitiveRightTimes:(NSNumber*)value;

- (int32_t)primitiveRightTimesValue;
- (void)setPrimitiveRightTimesValue:(int32_t)value_;




- (NSString*)primitiveSentencePattern;
- (void)setPrimitiveSentencePattern:(NSString*)value;




- (NSNumber*)primitiveTypeID;
- (void)setPrimitiveTypeID:(NSNumber*)value;

- (int32_t)primitiveTypeIDValue;
- (void)setPrimitiveTypeIDValue:(int32_t)value_;




- (NSString*)primitiveUserID;
- (void)setPrimitiveUserID:(NSString*)value;




- (NSNumber*)primitiveWrongTimes;
- (void)setPrimitiveWrongTimes:(NSNumber*)value;

- (int32_t)primitiveWrongTimesValue;
- (void)setPrimitiveWrongTimesValue:(int32_t)value_;




@end
