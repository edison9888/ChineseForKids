// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GroupModel.h instead.

#import <CoreData/CoreData.h>


extern const struct GroupModelAttributes {
	__unsafe_unretained NSString *groupID;
	__unsafe_unretained NSString *groupIconURL;
	__unsafe_unretained NSString *groupName;
	__unsafe_unretained NSString *humanID;
} GroupModelAttributes;

extern const struct GroupModelRelationships {
} GroupModelRelationships;

extern const struct GroupModelFetchedProperties {
} GroupModelFetchedProperties;







@interface GroupModelID : NSManagedObjectID {}
@end

@interface _GroupModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (GroupModelID*)objectID;





@property (nonatomic, strong) NSNumber* groupID;



@property int32_t groupIDValue;
- (int32_t)groupIDValue;
- (void)setGroupIDValue:(int32_t)value_;

//- (BOOL)validateGroupID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* groupIconURL;



//- (BOOL)validateGroupIconURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* groupName;



//- (BOOL)validateGroupName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* humanID;



@property int32_t humanIDValue;
- (int32_t)humanIDValue;
- (void)setHumanIDValue:(int32_t)value_;

//- (BOOL)validateHumanID:(id*)value_ error:(NSError**)error_;






@end

@interface _GroupModel (CoreDataGeneratedAccessors)

@end

@interface _GroupModel (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveGroupID;
- (void)setPrimitiveGroupID:(NSNumber*)value;

- (int32_t)primitiveGroupIDValue;
- (void)setPrimitiveGroupIDValue:(int32_t)value_;




- (NSString*)primitiveGroupIconURL;
- (void)setPrimitiveGroupIconURL:(NSString*)value;




- (NSString*)primitiveGroupName;
- (void)setPrimitiveGroupName:(NSString*)value;




- (NSNumber*)primitiveHumanID;
- (void)setPrimitiveHumanID:(NSNumber*)value;

- (int32_t)primitiveHumanIDValue;
- (void)setPrimitiveHumanIDValue:(int32_t)value_;




@end
