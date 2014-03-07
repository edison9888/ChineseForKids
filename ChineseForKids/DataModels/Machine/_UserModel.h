// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to UserModel.h instead.

#import <CoreData/CoreData.h>


extern const struct UserModelAttributes {
	__unsafe_unretained NSString *userEmail;
	__unsafe_unretained NSString *userID;
	__unsafe_unretained NSString *userName;
} UserModelAttributes;

extern const struct UserModelRelationships {
} UserModelRelationships;

extern const struct UserModelFetchedProperties {
} UserModelFetchedProperties;






@interface UserModelID : NSManagedObjectID {}
@end

@interface _UserModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (UserModelID*)objectID;





@property (nonatomic, strong) NSString* userEmail;



//- (BOOL)validateUserEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* userID;



//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* userName;



//- (BOOL)validateUserName:(id*)value_ error:(NSError**)error_;






@end

@interface _UserModel (CoreDataGeneratedAccessors)

@end

@interface _UserModel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveUserEmail;
- (void)setPrimitiveUserEmail:(NSString*)value;




- (NSString*)primitiveUserID;
- (void)setPrimitiveUserID:(NSString*)value;




- (NSString*)primitiveUserName;
- (void)setPrimitiveUserName:(NSString*)value;




@end
