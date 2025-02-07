//
//  CharactersListVCTest.m
//  MarvelApp
//
//  Created by Amr Elghadban on 5/17/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CharactersListVC.h"

@interface CharactersListVCTest : XCTestCase

@end

@implementation CharactersListVCTest

CharactersListVC * charactersListVC;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    charactersListVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"CharactersListVC"];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTableViewLoading {
    
    XCTAssertNil(charactersListVC.charactersTableView,"Before loading the table view should be nil");

}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
