// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PinyinModel.m instead.

#import "_PinyinModel.h"

const struct PinyinModelAttributes PinyinModelAttributes = {
	.audio = @"audio",
	.chinese = @"chinese",
	.english = @"english",
	.knowledgeID = @"knowledgeID",
	.lessonID = @"lessonID",
	.phoneme = @"phoneme",
	.phonemeCount = @"phonemeCount",
	.pinyin = @"pinyin",
	.progress = @"progress",
	.rightTimes = @"rightTimes",
	.tone = @"tone",
	.typeID = @"typeID",
	.userID = @"userID",
	.wrongTimes = @"wrongTimes",
};

const struct PinyinModelRelationships PinyinModelRelationships = {
};

const struct PinyinModelFetchedProperties PinyinModelFetchedProperties = {
};

@implementation PinyinModelID
@end

@implementation _PinyinModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PinyinModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PinyinModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PinyinModel" inManagedObjectContext:moc_];
}

- (PinyinModelID*)objectID {
	return (PinyinModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"knowledgeIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"knowledgeID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lessonIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lessonID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"phonemeCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"phonemeCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"progressValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"progress"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"rightTimesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rightTimes"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"typeIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"typeID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"wrongTimesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"wrongTimes"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic audio;






@dynamic chinese;






@dynamic english;






@dynamic knowledgeID;



- (int32_t)knowledgeIDValue {
	NSNumber *result = [self knowledgeID];
	return [result intValue];
}

- (void)setKnowledgeIDValue:(int32_t)value_ {
	[self setKnowledgeID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveKnowledgeIDValue {
	NSNumber *result = [self primitiveKnowledgeID];
	return [result intValue];
}

- (void)setPrimitiveKnowledgeIDValue:(int32_t)value_ {
	[self setPrimitiveKnowledgeID:[NSNumber numberWithInt:value_]];
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





@dynamic phoneme;






@dynamic phonemeCount;



- (int32_t)phonemeCountValue {
	NSNumber *result = [self phonemeCount];
	return [result intValue];
}

- (void)setPhonemeCountValue:(int32_t)value_ {
	[self setPhonemeCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePhonemeCountValue {
	NSNumber *result = [self primitivePhonemeCount];
	return [result intValue];
}

- (void)setPrimitivePhonemeCountValue:(int32_t)value_ {
	[self setPrimitivePhonemeCount:[NSNumber numberWithInt:value_]];
}





@dynamic pinyin;






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





@dynamic rightTimes;



- (int32_t)rightTimesValue {
	NSNumber *result = [self rightTimes];
	return [result intValue];
}

- (void)setRightTimesValue:(int32_t)value_ {
	[self setRightTimes:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRightTimesValue {
	NSNumber *result = [self primitiveRightTimes];
	return [result intValue];
}

- (void)setPrimitiveRightTimesValue:(int32_t)value_ {
	[self setPrimitiveRightTimes:[NSNumber numberWithInt:value_]];
}





@dynamic tone;






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





@dynamic userID;






@dynamic wrongTimes;



- (int32_t)wrongTimesValue {
	NSNumber *result = [self wrongTimes];
	return [result intValue];
}

- (void)setWrongTimesValue:(int32_t)value_ {
	[self setWrongTimes:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveWrongTimesValue {
	NSNumber *result = [self primitiveWrongTimes];
	return [result intValue];
}

- (void)setPrimitiveWrongTimesValue:(int32_t)value_ {
	[self setPrimitiveWrongTimes:[NSNumber numberWithInt:value_]];
}










@end
