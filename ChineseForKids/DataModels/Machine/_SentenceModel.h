// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SentenceModel.h instead.

#import <CoreData/CoreData.h>


extern const struct SentenceModelAttributes {
	__unsafe_unretained NSString *audio;
	__unsafe_unretained NSString *knowledgeID;
	__unsafe_unretained NSString *lessonID;
	__unsafe_unretained NSString *sentence;
	__unsafe_unretained NSString *sentenceID;
	__unsafe_unretained NSString *typeID;
	__unsafe_unretained NSString *userID;
	__unsafe_unretained NSString *worderOrder;
} SentenceModelAttributes;

extern const struct SentenceModelRelationships {
} SentenceModelRelationships;

extern const struct SentenceModelFetchedProperties {
} SentenceModelFetchedProperties;











@interface SentenceModelID : NSManagedObjectID {}
@end

@interface _SentenceModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SentenceModelID*)objectID;





@property (nonatomic, strong) NSString* audio;



//- (BOOL)validateAudio:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) NSString* sentence;



//- (BOOL)validateSentence:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* sentenceID;



@property int32_t sentenceIDValue;
- (int32_t)sentenceIDValue;
- (void)setSentenceIDValue:(int32_t)value_;

//- (BOOL)validateSentenceID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* typeID;



@property int32_t typeIDValue;
- (int32_t)typeIDValue;
- (void)setTypeIDValue:(int32_t)value_;

//- (BOOL)validateTypeID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* userID;



//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* worderOrder;



//- (BOOL)validateWorderOrder:(id*)value_ error:(NSError**)error_;






@end

@interface _SentenceModel (CoreDataGeneratedAccessors)

@end

@interface _SentenceModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAudio;
- (void)setPrimitiveAudio:(NSString*)value;




- (NSNumber*)primitiveKnowledgeID;
- (void)setPrimitiveKnowledgeID:(NSNumber*)value;

- (int32_t)primitiveKnowledgeIDValue;
- (void)setPrimitiveKnowledgeIDValue:(int32_t)value_;




- (NSNumber*)primitiveLessonID;
- (void)setPrimitiveLessonID:(NSNumber*)value;

- (int32_t)primitiveLessonIDValue;
- (void)setPrimitiveLessonIDValue:(int32_t)value_;




- (NSString*)primitiveSentence;
- (void)setPrimitiveSentence:(NSString*)value;




- (NSNumber*)primitiveSentenceID;
- (void)setPrimitiveSentenceID:(NSNumber*)value;

- (int32_t)primitiveSentenceIDValue;
- (void)setPrimitiveSentenceIDValue:(int32_t)value_;




- (NSNumber*)primitiveTypeID;
- (void)setPrimitiveTypeID:(NSNumber*)value;

- (int32_t)primitiveTypeIDValue;
- (void)setPrimitiveTypeIDValue:(int32_t)value_;




- (NSString*)primitiveUserID;
- (void)setPrimitiveUserID:(NSString*)value;




- (NSString*)primitiveWorderOrder;
- (void)setPrimitiveWorderOrder:(NSString*)value;




@end
