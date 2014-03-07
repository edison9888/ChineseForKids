// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SentenceModel.m instead.

#import "_SentenceModel.h"

const struct SentenceModelAttributes SentenceModelAttributes = {
	.audio = @"audio",
	.knowledgeID = @"knowledgeID",
	.lessonID = @"lessonID",
	.sentence = @"sentence",
	.sentenceID = @"sentenceID",
	.typeID = @"typeID",
	.userID = @"userID",
	.worderOrder = @"worderOrder",
};

const struct SentenceModelRelationships SentenceModelRelationships = {
};

const struct SentenceModelFetchedProperties SentenceModelFetchedProperties = {
};

@implementation SentenceModelID
@end

@implementation _SentenceModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SentenceModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SentenceModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SentenceModel" inManagedObjectContext:moc_];
}

- (SentenceModelID*)objectID {
	return (SentenceModelID*)[super objectID];
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
	if ([key isEqualToString:@"sentenceIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sentenceID"];
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




@dynamic audio;






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





@dynamic sentence;






@dynamic sentenceID;



- (int32_t)sentenceIDValue {
	NSNumber *result = [self sentenceID];
	return [result intValue];
}

- (void)setSentenceIDValue:(int32_t)value_ {
	[self setSentenceID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveSentenceIDValue {
	NSNumber *result = [self primitiveSentenceID];
	return [result intValue];
}

- (void)setPrimitiveSentenceIDValue:(int32_t)value_ {
	[self setPrimitiveSentenceID:[NSNumber numberWithInt:value_]];
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





@dynamic userID;






@dynamic worderOrder;











@end
