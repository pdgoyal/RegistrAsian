 //
//  APIService.swift
//  EMan
//
//  Created by Developer 1 on 15/08/2018.
//  Copyright © 2018 AppDev. All rights reserved.
//

import Foundation
import Alamofire


class APIService
{
let eventAPIKey: String
let eventBaseURL: URL?

//static let kEventID = "id"
init(APIKey: String)
{
    self.eventAPIKey = APIKey
    eventBaseURL = URL(string: BASE_URL)
}

func validatePasscode(passcode: String,
                      successBlock: @escaping (Event?) -> Void,
                      failureBlock: @escaping (Error) -> Void)
{
    let passcodeURL = URL (string: "\(PASSCODE_CHECKER_URL)/\(passcode)")
        
    
    Alamofire.request(passcodeURL!, method: .get).responseJSON { (response) in
            print(response)
        
           if let error = response.error
           {
            failureBlock(error)
            return
        }
                
                if let passcodeJSON = response.result.value as? [[String : Any]],
                    let passcodeObj = passcodeJSON.first {
                    print(passcodeObj)
                    let event = Event.init(JSON: passcodeObj);
                    successBlock(event)
            }

            }
    
    }

}

/*
    func getEventDetails(validPincode: String, completion: @escaping (Event?) -> Void)
    {
        let eventURL = URL (string: "\(PASSCODE_CHECKER_URL)/\(passcode)")
       
        Alamofire.request(passcodeURL!, method: .get).responseJSON { (response) in
        switch response.result{
        case .success:
            
            if let passcodeJSON = response.result.value as? [[String : Any]],
                let passcodeObj = passcodeJSON.first {
                print(passcodeObj)
                let event = Event.init(JSON: passcodeObj);
                completion(event)
            }
        case .failure(let error):
            print("\(error)")
        }
        
        
        
        
    }
}
*/
    


    
    








