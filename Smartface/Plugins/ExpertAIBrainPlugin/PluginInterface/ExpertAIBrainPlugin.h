//
//  ExpertAIBrainPlugin.h
//  Smartface
//
//  Created by Mourad on 7/17/16.
//  Copyright © 2016 Smartface. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpertAIBrainPlugin : NSObject

- (void)feedBrainWithKnowledgeCLPsLocations:(NSArray*)clps andFactsLocation:(NSString*)facts;
- (void)initialize;
- (int) getNumberOfAnswers;
- (NSString*) getAnswerAtIndex:(int)index;
- (void) goNextWithAnswerAtIndex:(int)answerIndex;
- (void) goPrevious;

@end
