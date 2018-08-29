//
//  Event.swift
//  EMan
//
//  Created by Developer 1 on 13/08/2018.
//  Copyright © 2018 AppDev. All rights reserved.
//

import Foundation


struct Event {
    
    let id: String?
    let name: String
    let location: String
    let startDateTime: Date
    let endDateTime: String
    let deleteFlag: Bool?
    let deleteDateTime: String?
    let dateCreated: String?
    let hasRaffle: Bool?
    let registrationReq: Bool?
    let participantCount: Int
    let closedFlag: Bool?
    let closedDateTime: String?
    let reopenFlag: Bool?
    let reopenDateTime: String?


    init?(JSON: [String: Any]) {
        
        guard let eventID = JSON["event_id"] as? String,
            let eventName = JSON["event_name"] as? String,
            let eventLocation = JSON["event_location"] as? String,
            let startDateTime = JSON["start_datetime"] as? String,
            let endDateTime = JSON["end_datetime"] as? String,
            let participantCount = JSON["participant_count"] as? Int else {
                
                return nil
        }
        
        self.id = eventID
        self.name = eventName
        self.location = eventLocation
        self.endDateTime = endDateTime
        self.participantCount = participantCount
        
        if let formattedStartDateTime = getDateFromString(dateString: startDateTime, formatString: "yyyy-MM-dd'T'HH:mm:ss.SSS") {
            self.startDateTime = formattedStartDateTime
        }else {
            self.startDateTime = Date()
        }
        
        if let deleteFlag = JSON["delete_flag"] as? Bool {
            self.deleteFlag = deleteFlag
        }else {
            self.deleteFlag = nil
        }
        
        if let deletedDateTime = JSON["deleted_datetime"] as? String {
            self.deleteDateTime = deletedDateTime
        }else {
            self.deleteDateTime = nil
        }
        
        if let dateCreated = JSON["date_created"] as? String {
            self.dateCreated = dateCreated
        }else {
            self.dateCreated = nil
        }
        
        if let hasRaffle = JSON["hasRaffle"] as? Bool {
            self.hasRaffle = hasRaffle
        }else {
            self.hasRaffle = nil
        }
        
        if let registrationReq = JSON["registration_req"] as? Bool {
            self.registrationReq = registrationReq
        }else {
            self.registrationReq = nil
        }
        
        if let closedFlag = JSON["closed_flag"] as? Bool {
            self.closedFlag = closedFlag
        }else {
            self.closedFlag = nil
        }
        
        if let closedDateTime = JSON["closed_datetime"] as? String {
            self.closedDateTime = closedDateTime
        }else {
            self.closedDateTime = nil
        }
        
        if let reopenFlag = JSON["reopen_flag"] as? Bool {
            self.reopenFlag = reopenFlag
        }else {
            self.reopenFlag = nil
        }
        
        if let reopenDateTime = JSON["reopen_datetime"] as? String {
            self.reopenDateTime = reopenDateTime
        }else {
            self.reopenDateTime = nil
        }
        
    }
}

