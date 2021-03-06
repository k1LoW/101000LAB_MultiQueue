//
//  _01000LAB_MultiQueuePlugIn.m
//  101000LAB_MultiQueue
//
//  Created by k1LoW on 2014/02/26.
//  Copyright (c) 2014年 101000LAB. All rights reserved.
//

// It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering
#import <OpenGL/CGLMacro.h>

#import "_01000LAB_MultiQueuePlugIn.h"

#define	kQCPlugIn_Name				@"101000LAB_MultiQueue"
#define	kQCPlugIn_Description		@"MultiQueue for Iterator"

@implementation _01000LAB_MultiQueuePlugIn

// Here you need to declare the input / output properties as dynamic as Quartz Composer will handle their implementation
//@dynamic inputFoo, outputBar;
@dynamic inputValue, outputQueue, inputQueueIndex, inputFilling, inputResetSignal;

- (void) dealloc {
    [qQueue release];
    [super dealloc];
}

+ (NSDictionary *)attributes
{
	// Return a dictionary of attributes describing the plug-in (QCPlugInAttributeNameKey, QCPlugInAttributeDescriptionKey...).
    return @{QCPlugInAttributeNameKey:kQCPlugIn_Name, QCPlugInAttributeDescriptionKey:kQCPlugIn_Description};
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
	// Specify the optional attributes for property based ports (QCPortAttributeNameKey, QCPortAttributeDefaultValueKey...).

    if([key isEqualToString:@"inputValue"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Value", QCPortAttributeNameKey,
            [NSNumber numberWithDouble:0],  QCPortAttributeDefaultValueKey,
            nil];

    else if([key isEqualToString:@"outputQueue"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Queue", QCPortAttributeNameKey,
                nil];
    
    else if([key isEqualToString:@"inputQueueIndex"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Queue Index", QCPortAttributeNameKey,
                [NSNumber numberWithUnsignedInteger:1],  QCPortAttributeDefaultValueKey,
                nil];

    else if([key isEqualToString:@"inputFilling"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Filling", QCPortAttributeNameKey,
                [NSNumber numberWithBool:YES], QCPortAttributeDefaultValueKey,
                nil];

    else if([key isEqualToString:@"inputResetSignal"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
                @"Reset Signal", QCPortAttributeNameKey,
                [NSNumber numberWithBool:YES], QCPortAttributeDefaultValueKey,
                nil];

	return nil;
}

+ (QCPlugInExecutionMode)executionMode
{
	// Return the execution mode of the plug-in: kQCPlugInExecutionModeProvider, kQCPlugInExecutionModeProcessor, or kQCPlugInExecutionModeConsumer.
	return kQCPlugInExecutionModeProcessor;
}

+ (QCPlugInTimeMode)timeMode
{
	// Return the time dependency mode of the plug-in: kQCPlugInTimeModeNone, kQCPlugInTimeModeIdle or kQCPlugInTimeModeTimeBase.
	return kQCPlugInTimeModeNone;
}

- (id)init
{
	self = [super init];
	if (self) {
		// Allocate any permanent resource required by the plug-in.
        qQueue = [[NSMutableDictionary alloc] init];
	}

	return self;
}


@end

@implementation _01000LAB_MultiQueuePlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when rendering of the composition starts: perform any required setup for the plug-in.
	// Return NO in case of fatal failure (this will prevent rendering of the composition to start).

	return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when the plug-in instance starts being used by Quartz Composer.
}

- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
	/*
	Called by Quartz Composer whenever the plug-in instance needs to execute.
	Only read from the plug-in inputs and produce a result (by writing to the plug-in outputs or rendering to the destination OpenGL context) within that method and nowhere else.
	Return NO in case of failure during the execution (this will prevent rendering of the current frame to complete).

	The OpenGL context for rendering can be accessed and defined for CGL macros using:
	CGLContextObj cgl_ctx = [context CGLContextObj];
	*/
    NSString *initKey = [NSString stringWithFormat: @"queue%lu", (unsigned long)self.inputQueueIndex];
    if (self.inputFilling) {
      NSNumber *initNSNumber = [NSNumber numberWithDouble:self.inputValue];
      [qQueue setObject:initNSNumber forKey:initKey];
    }
    if (self.inputResetSignal) {
        NSNumber *initNSNumber = [NSNumber numberWithDouble:0];
        [qQueue setObject:initNSNumber forKey:initKey];
    }
    NSNumber *qOut = [qQueue objectForKey:initKey];
	self.outputQueue = [qOut doubleValue];

	return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when the plug-in instance stops being used by Quartz Composer.
}

- (void)stopExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when rendering of the composition stops: perform any required cleanup for the plug-in.
}

@end
