// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LessonModel.m instead.

#import "_LessonModel.h"

const struct LessonModelAttributes LessonModelAttributes = {
	.bookID = @"bookID",
	.dataVersion = @"dataVersion",
	.lessonID = @"lessonID",
	.lessonIndex = @"lessonIndex",
	.lessonName = @"lessonName",
	.locked = @"locked",
	.progress = @"progress",
	.score = @"score",
	.starAmount = @"starAmount",
	.typeID = @"typeID",
	.updateTime = @"updateTime",
	.userID = @"userID",
};

const struct LessonModelRelationships LessonModelRelationships = {
};

const struct LessonModelFetchedProperties LessonModelFetchedProperties = {
};

@implementation LessonModelID
@end

@implementation _LessonModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LessonModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LessonModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LessonModel" inManagedObjectContext:moc_];
}

- (LessonModelID*)objectID {
	return (LessonModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"bookIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"bookID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"dataVersionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"dataVersion"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lessonIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lessonID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lessonIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lessonIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lockedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"locked"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"progressValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"progress"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"scoreValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"score"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"starAmountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"starAmount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"typeIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"typeID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




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





@dynamic dataVersion;



- (float)dataVersionValue {
	NSNumber *result = [self dataVersion];
	return [result floatValue];
}

- (void)setDataVersionValue:(float)value_ {
	[self setDataVersion:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveDataVersionValue {
	NSNumber *result = [self primitiveDataVersion];
	return [result floatValue];
}

- (void)setPrimitiveDataVersionValue:(float)value_ {
	[self setPrimitiveDataVersion:[NSNumber numberWithFloat:value_]];
}





@dynamic lessonID;



- (int32_t)lessonIDValue {
	NSNumber *result = [self lessonID];
	return [result intValue];
}

- (void)setLessonIDValue:(int32_t)value_ {
	[self setLessonID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLessonIDValue {
	NSNumber *result = [self primitiveLessonID];
	return [result intValue];
}

- (void)setPrimitiveLessonIDValue:(int32_t)value_ {
	[self setPrimitiveLessonID:[NSNumber numberWithInt:value_]];
}





@dynamic lessonIndex;



- (float)lessonIndexValue {
	NSNumber *result = [self lessonIndex];
	return [result floatValue];
}

- (void)setLessonIndexValue:(float)value_ {
	[self setLessonIndex:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLessonIndexValue {
	NSNumber *result = [self primitiveLessonIndex];
	return [result floatValue];
}

- (void)setPrimitiveLessonIndexValue:(float)value_ {
	[self setPrimitiveLessonIndex:[NSNumber numberWithFloat:value_]];
}





@dynamic lessonName;






@dynamic locked;



- (BOOL)lockedValue {
	NSNumber *result = [self locked];
	return [result boolValue];
}

- (void)setLockedValue:(BOOL)value_ {
	[self setLocked:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveLockedValue {
	NSNumber *result = [self primitiveLocked];
	return [result boolValue];
}

- (void)setPrimitiveLockedValue:(BOOL)value_ {
	[self setPrimitiveLocked:[NSNumber numberWithBool:value_]];
}





@dynamic progress;



- (float)progressValue {
	NSNumber *result = [self progress];
	return [result floatValue];
}

- (void)setProgressValue:(float)value_ {
	[self setProgress:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveProgressValue {
	NSNumber *result = [self primitiveProgress];
	return [result floatValue];
}

- (void)setPrimitiveProgressValue:(float)value_ {
	[self setPrimitiveProgress:[NSNumber numberWithFloat:value_]];
}





@dynamic score;



- (int32_t)scoreValue {
	NSNumber *result = [self score];
	return [result intValue];
}

- (void)setScoreValue:(int32_t)value_ {
	[self setScore:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveScoreValue {
	NSNumber *result = [self primitiveScore];
	return [result intValue];
}

- (void)setPrimitiveScoreValue:(int32_t)value_ {
	[self setPrimitiveScore:[NSNumber numberWithInt:value_]];
}





@dynamic starAmount;



- (int32_t)starAmountValue {
	NSNumber *result = [self starAmount];
	return [result intValue];
}

- (void)setStarAmountValue:(int32_t)value_ {
	[self setStarAmount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveStarAmountValue {
	NSNumber *result = [self primitiveStarAmount];
	return [result intValue];
}

- (void)setPrimitiveStarAmountValue:(int32_t)value_ {
	[self setPrimitiveStarAmount:[NSNumber numberWithInt:value_]];
}





@dynamic typeID;



- (int32_t)typeIDValue {
	NSNumber *result = [self typeID];
	return [result intValue];
}

- (void)setTypeIDValue:(int32_t)value_ {
	[self setTypeID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTypeIDValue {
	NSNumber *result = [self primitiveTypeID];
	return [result intValue];
}

- (void)setPrimitiveTypeIDValue:(int32_t)value_ {
	[self setPrimitiveTypeID:[NSNumber numberWithInt:value_]];
}





@dynamic updateTime;






@dynamic userID;











@end
