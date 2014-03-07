// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookModel.h instead.

#import <CoreData/CoreData.h>


extern const struct BookModelAttributes {
	__unsafe_unretained NSString *bookAuthor;
	__unsafe_unretained NSString *bookID;
	__unsafe_unretained NSString *bookIconURL;
	__unsafe_unretained NSString *bookIntro;
	__unsafe_unretained NSString *bookName;
	__unsafe_unretained NSString *bookPublishDate;
	__unsafe_unretained NSString *groupID;
} BookModelAttributes;

extern const struct BookModelRelationships {
} BookModelRelationships;

extern const struct BookModelFetchedProperties {
} BookModelFetchedProperties;










@interface BookModelID : NSManagedObjectID {}
@end

@interface _BookModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BookModelID*)objectID;





@property (nonatomic, strong) NSString* bookAuthor;



//- (BOOL)validateBookAuthor:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* bookID;



@property int32_t bookIDValue;
- (int32_t)bookIDValue;
- (void)setBookIDValue:(int32_t)value_;

//- (BOOL)validateBookID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* bookIconURL;



//- (BOOL)validateBookIconURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* bookIntro;



//- (BOOL)validateBookIntro:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* bookName;



//- (BOOL)validateBookName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* bookPublishDate;



//- (BOOL)validateBookPublishDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* groupID;



@property int32_t groupIDValue;
- (int32_t)groupIDValue;
- (void)setGroupIDValue:(int32_t)value_;

//- (BOOL)validateGroupID:(id*)value_ error:(NSError**)error_;






@end

@interface _BookModel (CoreDataGeneratedAccessors)

@end

@interface _BookModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBookAuthor;
- (void)setPrimitiveBookAuthor:(NSString*)value;




- (NSNumber*)primitiveBookID;
- (void)setPrimitiveBookID:(NSNumber*)value;

- (int32_t)primitiveBookIDValue;
- (void)setPrimitiveBookIDValue:(int32_t)value_;




- (NSString*)primitiveBookIconURL;
- (void)setPrimitiveBookIconURL:(NSString*)value;




- (NSString*)primitiveBookIntro;
- (void)setPrimitiveBookIntro:(NSString*)value;




- (NSString*)primitiveBookName;
- (void)setPrimitiveBookName:(NSString*)value;




- (NSDate*)primitiveBookPublishDate;
- (void)setPrimitiveBookPublishDate:(NSDate*)value;




- (NSNumber*)primitiveGroupID;
- (void)setPrimitiveGroupID:(NSNumber*)value;

- (int32_t)primitiveGroupIDValue;
- (void)setPrimitiveGroupIDValue:(int32_t)value_;




@end
