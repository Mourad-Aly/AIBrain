//
//  ExpertAIBrainPlugin.m
//  Smartface
//
//  Created by Mourad on 7/17/16.
//  Copyright © 2016 Smartface. All rights reserved.
//

#import "ExpertAIBrainPlugin.h"
#import <CLIPSiOS/clips.h>

#ifdef SMARTFACE_PRODUCTION
#include <iOSPlayer/inc/SMFJSObject.h>
#else
#import "SMFJSObject.h"
#endif

@interface ExpertAIBrainPlugin()
{
    void *clipsEnv;
    
}
@property (nonatomic, retain) NSString *relationAsserted;
@property (nonatomic, retain) NSMutableArray *validAnswers;
@property (nonatomic, retain) NSMutableArray *displayAnswers;
@property (nonatomic, retain) NSMutableArray *variableAsserts;
@property (nonatomic, retain) NSMutableArray *priorAnswers;
@property (nonatomic, assign) NSInteger interviewState;
@property (nonatomic, retain) SMFJSObject *smfJSObject;

@property (nonatomic, retain) NSArray* clpsLocations;
@property (nonatomic, retain) NSString* factsLocation;
@end

@implementation ExpertAIBrainPlugin

enum interviewStateValues
{
    kGreeting = 0,
    kInterview,
    kConclusion
};

NSString *kRestoreVariableAssertsKey = @"VariableAsserts";
NSString *kRestorePriorAnswersKey = @"PriorAnswers";
NSString *kRestoreCurrentAnswerKey = @"CurrentAnswer";


- (void)feedBrainWithKnowledgeCLPsLocations:(NSArray*)clps andFactsLocation:(NSString*)facts {
    self.clpsLocations = clps;
    self.factsLocation = facts;
}
- (void)initialize {
    NSString *filePath;
    char *cFilePath;
    NSNumber *currentAnswer;
    
    self.variableAsserts = [[[NSUserDefaults standardUserDefaults] valueForKey: kRestoreVariableAssertsKey] mutableCopy];
    self.priorAnswers = [[[NSUserDefaults standardUserDefaults] valueForKey: kRestorePriorAnswersKey] mutableCopy];
    currentAnswer = [[NSUserDefaults standardUserDefaults] valueForKey: kRestoreCurrentAnswerKey];
    
    if (self.variableAsserts == nil)
    { self.variableAsserts = [NSMutableArray arrayWithCapacity: 10]; }
    if (self.priorAnswers == nil)
    { self.priorAnswers = [NSMutableArray arrayWithCapacity: 10]; }
    
    clipsEnv = CreateEnvironment();
    if (clipsEnv == NULL) return;
    
    for (NSString *clpLocation in self.clpsLocations) {
        filePath = [[NSBundle mainBundle]pathForResource:clpLocation ofType:@"clp"];
        cFilePath = (char *) [filePath UTF8String];
        EnvLoad(clipsEnv,cFilePath);
    }
    
    self.validAnswers = [NSMutableArray arrayWithCapacity: 2];
    self.displayAnswers = [NSMutableArray arrayWithCapacity: 2];
    
    [self processRules];
}

- (int) getNumberOfAnswers
{
    return [self.displayAnswers count];
}

- (NSString*) getAnswerAtIndex:(int)index
{
    return [self.displayAnswers objectAtIndex: index];
}

- (void) evalString: (NSString *) evalString
{
    char *cEvalString;
    DATA_OBJECT theRV;
    
    cEvalString = (char *) [evalString UTF8String];
    EnvEval(clipsEnv,cEvalString,&theRV);
}

- (void) handleResponse
{
    DATA_OBJECT theDO;
    struct multifield *theMultifield;
    void *theFact;
    const char *theString;
    
    EnvEval(clipsEnv,"(find-fact ((?f UI-state)) TRUE)",&theDO);
    
    if ((GetType(theDO) != MULTIFIELD) ||
        (GetDOLength(theDO) == 0)) return;
    
    theMultifield = GetValue(theDO);
    if (GetMFType(theMultifield,1) != FACT_ADDRESS) return;
    
    theFact = GetMFValue(theMultifield,1);
    
    /*=================================*/
    /* Process state slot of response. */
    /*=================================*/
    
    EnvGetFactSlot(clipsEnv,theFact,"state",&theDO);
    if ((GetType(theDO) == SYMBOL) || (GetType(theDO) == STRING))
    { theString = DOToString(theDO); }
    else
    { theString = ""; }
    
    if (strcmp(theString,"greeting") == 0)
    {
        self.interviewState = kGreeting;
        
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"setPreviousButtonHidden" object:@"Yes"];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"setNextButtonHidden" object:@"No"];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"setAnswerViewHidden" object:@"Yes"];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"setNextButtonTitle" object:@"Next"];
        
        SMFJSObject *readFunction = [self.smfJSObject getProperty:@"setPreviousButtonHidden"];
        [self.smfJSObject callAsFunction:readFunction withArgs:@[[[SMFJSObject alloc] initWithString:@"Yes"]]];
        [readFunction release];
        
        readFunction = [self.smfJSObject getProperty:@"setNextButtonHidden"];
        [self.smfJSObject callAsFunction:readFunction withArgs:@[[[SMFJSObject alloc] initWithString:@"No"]]];
        [readFunction release];
        
        readFunction = [self.smfJSObject getProperty:@"setAnswerViewHidden"];
        [self.smfJSObject callAsFunction:readFunction withArgs:@[[[SMFJSObject alloc] initWithString:@"Yes"]]];
        [readFunction release];
        
        readFunction = [self.smfJSObject getProperty:@"setNextButtonTitle"];
        [self.smfJSObject callAsFunction:readFunction withArgs:@[[[SMFJSObject alloc] initWithString:@"Next"]]];
        [readFunction release];
    }
    else if (strcmp(theString,"interview") == 0)
    {
        self.interviewState = kInterview;
        
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"setPreviousButtonHidden" object:@"No"];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"setNextButtonHidden" object:@"No"];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"setAnswerViewHidden" object:@"No"];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"setNextButtonTitle" object:@"Next"];
        
        SMFJSObject *readFunction = [self.smfJSObject getProperty:@"setPreviousButtonHidden"];
        [self.smfJSObject callAsFunction:readFunction withArgs:@[[[SMFJSObject alloc] initWithString:@"NO"]]];
        [readFunction release];
        
        readFunction = [self.smfJSObject getProperty:@"setNextButtonHidden"];
        [self.smfJSObject callAsFunction:readFunction withArgs:@[[[SMFJSObject alloc] initWithString:@"No"]]];
        [readFunction release];
        
        readFunction = [self.smfJSObject getProperty:@"setAnswerViewHidden"];
        [self.smfJSObject callAsFunction:readFunction withArgs:@[[[SMFJSObject alloc] initWithString:@"NO"]]];
        [readFunction release];
        
        readFunction = [self.smfJSObject getProperty:@"setNextButtonTitle"];
        [self.smfJSObject callAsFunction:readFunction withArgs:@[[[SMFJSObject alloc] initWithString:@"Next"]]];
        [readFunction release];
    }
    else if (strcmp(theString,"conclusion") == 0)
    {
        self.interviewState = kConclusion;
        
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"setPreviousButtonHidden" object:@"No"];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"setNextButtonHidden" object:@"No"];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"setAnswerViewHidden" object:@"Yes"];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"setNextButtonTitle" object:@"Restart"];
        
        SMFJSObject *readFunction = [self.smfJSObject getProperty:@"setPreviousButtonHidden"];
        [self.smfJSObject callAsFunction:readFunction withArgs:@[[[SMFJSObject alloc] initWithString:@"NO"]]];
        [readFunction release];
        
        readFunction = [self.smfJSObject getProperty:@"setNextButtonHidden"];
        [self.smfJSObject callAsFunction:readFunction withArgs:@[[[SMFJSObject alloc] initWithString:@"No"]]];
        [readFunction release];
        
        readFunction = [self.smfJSObject getProperty:@"setAnswerViewHidden"];
        [self.smfJSObject callAsFunction:readFunction withArgs:@[[[SMFJSObject alloc] initWithString:@"Yes"]]];
        [readFunction release];
        
        readFunction = [self.smfJSObject getProperty:@"setNextButtonTitle"];
        [self.smfJSObject callAsFunction:readFunction withArgs:@[[[SMFJSObject alloc] initWithString:@"Restart"]]];
        [readFunction release];
    }
    
    /*===================================*/
    /* Process display slot of response. */
    /*===================================*/
    
    EnvGetFactSlot(clipsEnv,theFact,"display",&theDO);
    
    if ((GetType(theDO) == SYMBOL) || (GetType(theDO) == STRING))
    { theString = DOToString(theDO); }
    else
    { theString = ""; }
    
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"setDisplay" object:[NSString stringWithCString: theString encoding: NSUTF8StringEncoding]];
    
    SMFJSObject *readFunction = [self.smfJSObject getProperty:@"setDisplay"];
    [self.smfJSObject callAsFunction:readFunction withArgs:@[[[SMFJSObject alloc] initWithString:[NSString stringWithCString: theString encoding: NSUTF8StringEncoding]]]];
    [readFunction release];
    
    /*=============================================*/
    /* Process relation-asserted slot of response. */
    /*=============================================*/
    
    EnvGetFactSlot(clipsEnv,theFact,"relation-asserted",&theDO);
    
    if ((GetType(theDO) == SYMBOL) || (GetType(theDO) == STRING))
    { theString = DOToString(theDO); }
    else
    { theString = ""; }
    
    self.relationAsserted = [NSString stringWithCString: theString encoding: NSUTF8StringEncoding];
    
    /*=========================================*/
    /* Process valid-answers slot of response. */
    /*=========================================*/
    
    [self.validAnswers removeAllObjects];
    
    EnvGetFactSlot(clipsEnv,theFact,"valid-answers",&theDO);
    
    if (GetType(theDO) == MULTIFIELD)
    {
        int i;
        
        theMultifield = GetValue(theDO);
        
        for (i = 1; i <= GetDOLength(theDO); i++)
        {
            if ((GetMFType(theMultifield,i) == SYMBOL) ||
                (GetMFType(theMultifield,i) == STRING))
            {
                theString = ValueToString(GetMFValue(theMultifield,i));
                [self.validAnswers addObject: [NSString stringWithCString: theString encoding: NSUTF8StringEncoding]];
            }
        }
    }
    
    /*=========================================*/
    /* Process valid-answers slot of response. */
    /*=========================================*/
    
    [self.displayAnswers removeAllObjects];
    
    EnvGetFactSlot(clipsEnv,theFact,"display-answers",&theDO);
    
    if (GetType(theDO) == MULTIFIELD)
    {
        int i;
        
        theMultifield = GetValue(theDO);
        
        for (i = 1; i <= GetDOLength(theDO); i++)
        {
            if ((GetMFType(theMultifield,i) == SYMBOL) ||
                (GetMFType(theMultifield,i) == STRING))
            {
                theString = ValueToString(GetMFValue(theMultifield,i));
                [self.displayAnswers addObject: [NSString stringWithCString: theString encoding: NSUTF8StringEncoding]];
            }
        }
    }
    
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"reloadAnswers" object:@"No"];
    readFunction = [self.smfJSObject getProperty:@"reloadAnswers"];
    [self.smfJSObject callAsFunction:readFunction withArgs:@[[[SMFJSObject alloc] initWithString:@"No"]]];
    [readFunction release];
}


- (void) processRules
{
    NSString *filePath;
    char *cFilePath;
    long long rulesFired;
    NSString *factString, *assertCommand;
    
    /*==============*/
    /* Reset CLIPS. */
    /*==============*/
    
    EnvReset(clipsEnv);
    
    /*========================*/
    /* Load the animal facts. */
    /*========================*/
    
    filePath = [[NSBundle mainBundle]pathForResource:self.factsLocation ofType:@"fct"];
    cFilePath = (char *) [filePath UTF8String];
    EnvLoadFacts(clipsEnv,cFilePath);
    
    for (factString in self.variableAsserts)
    {
        assertCommand = [NSString stringWithFormat: @"(assert %@)",factString];
        [self evalString: assertCommand];
    }
    
    rulesFired = EnvRun(clipsEnv,-1);
    
    [self handleResponse];
}


- (void) goNextWithAnswerAtIndex:(int)answerIndex
{
    NSString *theString;
    
    switch (self.interviewState)
    {
            /* Handle Next button. */
        case kGreeting:
        case kInterview:
            if (self.clpsLocations.count > 1 )
                theString = [NSString stringWithFormat:
                         @"(variable (name %@) (value %@))",
                         self.relationAsserted,
                         [self.validAnswers objectAtIndex: answerIndex]];
            else
                theString = [NSString stringWithFormat: @"(%@ %@)",
                             self.relationAsserted,
                             [self.validAnswers objectAtIndex: answerIndex]];
            [self.variableAsserts addObject: theString];
            [self.priorAnswers addObject: [NSNumber numberWithInteger: answerIndex]];
            break;
            
            /* Handle Restart button. */
        case kConclusion:
            [self.variableAsserts removeAllObjects];
            [self.priorAnswers removeAllObjects];
            break;
    }
    [self processRules];
    
    //    [answerPickerView selectRow: 0 inComponent: 0 animated: NO];
    
}


- (void) goPrevious {
    NSInteger lastAnswer;
    
    lastAnswer = [[self.priorAnswers lastObject] integerValue];
    
    [self.variableAsserts removeLastObject];
    [self.priorAnswers removeLastObject];
    
    [self processRules];
    
    //    [answerPickerView selectRow: lastAnswer inComponent: 0 animated: NO];
}



/************/
/* saveData */
/************/
//- (void) saveData
//{
//
//    [[NSUserDefaults standardUserDefaults] setValue: variableAsserts forKey: kRestoreVariableAssertsKey];
//    [[NSUserDefaults standardUserDefaults] setValue: priorAnswers forKey: kRestorePriorAnswersKey];
//    [[NSUserDefaults standardUserDefaults] setValue: [NSNumber numberWithInteger: [answerPickerView selectedRowInComponent: 0]]
//                                             forKey: kRestoreCurrentAnswerKey];
//}

@end