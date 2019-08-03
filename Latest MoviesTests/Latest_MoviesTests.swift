//
//  Latest_MoviesTests.swift
//  Latest MoviesTests
//
//  Created by Ravi Gangwar on 03/08/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.
//

import XCTest
@testable import Latest_Movies

class Latest_MoviesTests: XCTestCase {

    var sut: URLSession!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = URLSession(configuration: .default)

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //MARK:-
    //MARR:- Pass Test Case to check Data in local DB
    func testDataInDb(){

        if let record = MovieRecordDBModel.getRecord(){
            assert(!(record.page>1), "Not validate")
        }else{
           // assert(!(record.page>1), "Not validate")
        }
    }

    //MARK:-
    //MARR:- Pass Test Case to connect with Api
    func testValidCallTothemoviedbGetsHTTPStatusCode200() {
        
        guard let url = URL(string: WebServices.EndPoint.popularMovie.path+"?api_key=\(AppConstant.Api_Key)") else{return}
        let promise = expectation(description: "Status code: 200")
        let dataTask = sut.dataTask(with: url) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }
    
    //MARK:-
    //MARR:- Falled Test Case to connect with Api
    func testInValidCallTothemoviedbGetsHTTPStatusCode() {
        
        guard let url = URL(string: WebServices.EndPoint.popularMovie.path+"?api_key=\(AppConstant.inValid_Api_Key)") else{return}
        
        let promise = expectation(description: "Status code: 200")
        let dataTask = sut.dataTask(with: url) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }
}
