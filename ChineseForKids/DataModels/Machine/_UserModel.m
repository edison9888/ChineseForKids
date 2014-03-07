// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to UserModel.m instead.

#import "_UserModel.h"

const struct UserModelAttributes UserModelAttributes = {
	.userEmail = @"userEmail",
	.userID = @"userID",
	.userName = @"userName",
};

const struct UserModelRelationships UserModelRelationships = {
};

const struct UserModelFetchedProperties UserModelFetchedProperties = {
};

@implementation UserModelID
@end

@implementation _UserModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"UserModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"UserModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"UserModel" inManagedObjectContext:moc_];
}

- (UserModelID*)objectID {
	return (UserModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic userEmail;






@dynamic userID;






@dynamic userName;











@end
