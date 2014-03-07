// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GroupModel.m instead.

#import "_GroupModel.h"

const struct GroupModelAttributes GroupModelAttributes = {
	.groupID = @"groupID",
	.groupIconURL = @"groupIconURL",
	.groupName = @"groupName",
	.humanID = @"humanID",
};

const struct GroupModelRelationships GroupModelRelationships = {
};

const struct GroupModelFetchedProperties GroupModelFetchedProperties = {
};

@implementation GroupModelID
@end

@implementation _GroupModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"GroupModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"GroupModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"GroupModel" inManagedObjectContext:moc_];
}

- (GroupModelID*)objectID {
	return (GroupModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"groupIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"groupID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"humanIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"humanID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic groupID;



- (int32_t)groupIDValue {
	NSNumber *result = [self groupID];
	return [result intValue];
}

- (void)setGroupIDValue:(int32_t)value_ {
	[self setGroupID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveGroupIDValue {
	NSNumber *result = [self primitiveGroupID];
	return [result intValue];
}

- (void)setPrimitiveGroupIDValue:(int32_t)value_ {
	[self setPrimitiveGroupID:[NSNumber numberWithInt:value_]];
}





@dynamic groupIconURL;






@dynamic groupName;






@dynamic humanID;



- (int32_t)humanIDValue {
	NSNumber *result = [self humanID];
	return [result intValue];
}

- (void)setHumanIDValue:(int32_t)value_ {
	[self setHumanID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveHumanIDValue {
	NSNumber *result = [self primitiveHumanID];
	return [result intValue];
}

- (void)setPrimitiveHumanIDValue:(int32_t)value_ {
	[self setPrimitiveHumanID:[NSNumber numberWithInt:value_]];
}










@end
