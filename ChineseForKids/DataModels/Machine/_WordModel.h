// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WordModel.h instead.

#import <CoreData/CoreData.h>


extern const struct WordModelAttributes {
	__unsafe_unretained NSString *audio;
	__unsafe_unretained NSString *english;
	__unsafe_unretained NSString *knowledgeID;
	__unsafe_unretained NSString *lessonID;
	__unsafe_unretained NSString *obstruction;
	__unsafe_unretained NSString *pinyin;
	__unsafe_unretained NSString *progress;
	__unsafe_unretained NSString *rightTimes;
	__unsafe_unretained NSString *rightWord;
	__unsafe_unretained NSString *typeID;
	__unsafe_unretained NSString *userID;
	__unsafe_unretained NSString *wrongTimes;
} WordModelAttributes;

extern const struct WordModelRelationships {
} WordModelRelationships;

extern const struct WordModelFetchedProperties {
} WordModelFetchedProperties;















@interface WordModelID : NSManagedObjectID {}
@end

@interface _WordModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WordModelID*)objectID;





@property (nonatomic, strong) NSString* audio;



//- (BOOL)validateAudio:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) NSString* obstruction;



//- (BOOL)validateObstruction:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* pinyin;



//- (BOOL)validatePinyin:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) NSString* rightWord;



//- (BOOL)validateRightWord:(id*)value_ error:(NSError**)error_;





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

@interface _WordModel (CoreDataGeneratedAccessors)

@end

@interface _WordModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAudio;
- (void)setPrimitiveAudio:(NSString*)value;




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




- (NSString*)primitiveObstruction;
- (void)setPrimitiveObstruction:(NSString*)value;




- (NSString*)primitivePinyin;
- (void)setPrimitivePinyin:(NSString*)value;




- (NSNumber*)primitiveProgress;
- (void)setPrimitiveProgress:(NSNumber*)value;

- (float)primitiveProgressValue;
- (void)setPrimitiveProgressValue:(float)value_;




- (NSNumber*)primitiveRightTimes;
- (void)setPrimitiveRightTimes:(NSNumber*)value;

- (int32_t)primitiveRightTimesValue;
- (void)setPrimitiveRightTimesValue:(int32_t)value_;




- (NSString*)primitiveRightWord;
- (void)setPrimitiveRightWord:(NSString*)value;




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
