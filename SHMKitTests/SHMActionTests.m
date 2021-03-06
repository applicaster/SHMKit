//
//  SHMActionTests.m
//  SHMKit
//
//  Created by Matthew Dobson on 4/25/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SHMAction.h"
#import "SHMRequestFactory.h"
#import "SHMParser.h"
#import "SHMEntity.h"
#import "SHMActionField.h"
#import "SHMEntityFactoryDelegate.h"
#import "SHMEntityFactory.h"
#import "SHMTestEntityFactoryDelegate.h"

@interface SHMActionTests : XCTestCase

@end

@implementation SHMActionTests

- (void)setUp
{
    [super setUp];
    [[SHMEntityFactory sharedFactory] setDelegate:[[SHMTestEntityFactoryDelegate alloc] init]];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testPost
{
    NSString *url = @"http://msiren.herokuapp.com/";
    SHMParser *parser = [[SHMParser alloc] initWithSirenRoot:url];
    [parser retrieveRoot:^(NSError *err, SHMEntity* entity){
        [entity stepToLinkRel:@"museums"
               withCompletion:^(NSError *err, SHMEntity *entity){
                   SHMAction *action = [entity getSirenAction:@"add-museum"];
                   NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"DIA", @"museum", @"5200 Woodward Ave.", @"address", @"Detroit", @"city", nil];
                   [action performActionWithFields:dict andCompletion:^(NSError *err, SHMEntity *ent) {
                       SHMEntityFactory *factory = [SHMEntityFactory sharedFactory];
                       XCTAssert(factory != nil, @"Factory isn't nil");
                       XCTAssert(factory.delegate != nil, @"Factory delegate isn't nil");
                       XCTAssert(err == nil, @"No error.");
                       XCTAssert([ent.class count] == 1, @"Class amount is incorrect");
                       XCTAssert([ent.entities count] == 0, @"Class amount is incorrect");
                       XCTAssert([ent.actions count] == 1, @"Class amount is incorrect");
                       XCTAssert([ent.links count] == 2, @"Class amount is incorrect");
                       XCTAssert([ent.properties[@"museum"] isEqualToString:@"DIA"] == YES, @"Musuem prop amount is incorrect");
                       XCTAssert([ent.properties[@"address"] isEqualToString:@"5200 Woodward Ave."] == YES, @"Musuem prop amount is incorrect");
                       XCTAssert([ent.properties[@"city"] isEqualToString:@"Detroit"] == YES, @"Musuem prop amount is incorrect");
                       
                    }];
               }];
    }];
}

- (void)testGet
{
    NSString *url = @"http://msiren.herokuapp.com/";
    SHMParser *parser = [[SHMParser alloc] initWithSirenRoot:url];
    [parser retrieveRoot:^(NSError *err, SHMEntity* entity){
        [entity stepToLinkRel:@"museums"
               withCompletion:^(NSError *err, SHMEntity *entity){
                   SHMAction *action = [entity getSirenAction:@"get-museums"];
                   NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"where museum='DIA'", @"query", @"5", @"limit", nil];
                   [action performActionWithFields:dict andCompletion:^(NSError *err, SHMEntity *ent) {
                       SHMEntityFactory *factory = [SHMEntityFactory sharedFactory];
                       XCTAssert(factory != nil, @"Factory isn't nil");
                       XCTAssert(factory.delegate != nil, @"Factory delegate isn't nil");
                       XCTAssert(err == nil, @"No error.");
                       XCTAssert([ent.class count] == 2, @"Class amount is incorrect");
                       XCTAssert([ent.entities count] == 1, @"Class amount is incorrect");
                       XCTAssert([ent.actions count] == 3, @"Class amount is incorrect");
                       XCTAssert([ent.links count] == 1, @"Class amount is incorrect");
                   }];
               }];
    }];
}

- (void)testDelete
{
    
    NSString *url = @"http://msiren.herokuapp.com/";
    SHMParser *parser = [[SHMParser alloc] initWithSirenRoot:url];
    [parser retrieveRoot:^(NSError *err, SHMEntity* entity){
        [entity stepToLinkRel:@"museums"
               withCompletion:^(NSError *err, SHMEntity *entity){
                   SHMAction *action = [entity getSirenAction:@"get-museums"];
                   NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"where museum='DIA'", @"query", @"5", @"limit", nil];
                   [action performActionWithFields:dict andCompletion:^(NSError *err, SHMEntity *ent) {
                       SHMEntityFactory *factory = [SHMEntityFactory sharedFactory];
                       XCTAssert(factory != nil, @"Factory isn't nil");
                       XCTAssert(factory.delegate != nil, @"Factory delegate isn't nil");
                       XCTAssert(err == nil, @"No error.");
                       SHMEntity *museum = ent.entities[0];
                       [museum stepToLinkRel:@"museums"
                              withCompletion:^(NSError *err, SHMEntity *entity){
                                  SHMAction *action = [entity getSirenAction:@"delete-museum"];
                                  [action performActionWithCompletion:^(NSError *err, SHMEntity *ent) {
                                        XCTAssert(err == nil, @"No error.");
                                  }];
                              }];
                   }];
               }];
    }];
}

- (void)testFieldParsing {
    NSString *url = @"http://msiren.herokuapp.com/";
    SHMParser *parser = [[SHMParser alloc] initWithSirenRoot:url];
    [parser retrieveRoot:^(NSError *err, SHMEntity* entity){
        [entity stepToLinkRel:@"museums"
               withCompletion:^(NSError *err, SHMEntity *entity){
                   SHMAction *action = [entity getSirenAction:@"get-museums"];
                   
                   XCTAssert(action.fields.count == 2, @"Improper number of fields");
                   SHMActionField *query = action.fields[0];
                   SHMActionField *limit = action.fields[1];
                   XCTAssert([query.name isEqualToString:@"query"], @"Improper name for query");
                   XCTAssert([limit.name isEqualToString:@"limit"], @"Improper name for limit");
                }];
    }];

}

@end
