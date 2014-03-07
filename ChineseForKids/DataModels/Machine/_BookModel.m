// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookModel.m instead.

#import "_BookModel.h"

const struct BookModelAttributes BookModelAttributes = {
	.bookAuthor = @"bookAuthor",
	.bookID = @"bookID",
	.bookIconURL = @"bookIconURL",
	.bookIntro = @"bookIntro",
	.bookName = @"bookName",
	.bookPublishDate = @"bookPublishDate",
	.groupID = @"groupID",
};

const struct BookModelRelationships BookModelRelationships = {
};

const struct BookModelFetchedProperties BookModelFetchedProperties = {
};

@implementation BookModelID
@end

@implementation _BookModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BookModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BookModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BookModel" inManagedObjectContext:moc_];
}

- (BookModelID*)objectID {
	return (BookModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"bookIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"bookID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"groupIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"groupID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic bookAuthor;






@dynamic bookID;



- (int32_t)bookIDValue {
	NSNumber *result = [self bookID];
	return [result intValue];
}

- (void)setBookIDValue:(int32_t)value_ {
	[self setBookID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveBookIDValue {
	NSNumber *result = [self primitiveBookID];
	return [result intValue];
}

- (void)setPrimitiveBookIDValue:(int32_t)value_ {
	[self setPrimitiveBookID:[NSNumber numberWithInt:value_]];
}





@dynamic bookIconURL;






@dynamic bookIntro;






@dynamic bookName;






@dynamic bookPublishDate;






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










@end
