//
//  Utilities.swift
//  20210610-JigarPatel-NYCSchools
//
//  Created by Jigar Patel on 10/06/21.
//

import Foundation

import Foundation
import CoreLocation
import MapKit

class Utilities {
    
    /// fetch the address without coodinates
    static func getCompleteAddressWithoutCoordinate(_ schoolAddr: String?) -> String{
        if let schoolAddress = schoolAddr{
            let address = schoolAddress.components(separatedBy: "(")
            return address[0]
        }
        return ""
    }
    
    /// fetch the coodinates for the selected High School location
    static func getCoodinateForSelectedHighSchool(_ schoolAddr: String?) -> CLLocationCoordinate2D?{
        if let schoolAddress = schoolAddr{
            let coordinateString = schoolAddress.slice(from: "(", to: ")")
            let coordinates = coordinateString?.components(separatedBy: ",")
            if let coordinateArray = coordinates{
                let latitude = (coordinateArray[0] as NSString).doubleValue
                let longitude = (coordinateArray[1] as NSString).doubleValue
                return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            }
        }
        return nil
    }
    
    
    ///  fetch JSON payload and assign parameter to the NYCHighSchools model
    static func getHSInfoWithJSON(_ json: [String: Any]) -> HighSchools?{
        if !json.isEmpty{
            let nycHighSchools = HighSchools()
            if let dbnObject = json["dbn"] as? String{
                nycHighSchools.dbn = dbnObject
            }
            
            if let schoolNameOnject = json["school_name"] as? String{
                nycHighSchools.schoolName = schoolNameOnject
            }
            
            if let overviewParagraphObject = json["overview_paragraph"] as? String{
                nycHighSchools.overviewParagraph = overviewParagraphObject
            }
            if let schoolAddressObject = json["location"] as? String{
                nycHighSchools.schoolAddress = schoolAddressObject
            }
            if let schoolTelObject = json["phone_number"] as? String{
                nycHighSchools.schoolTelephoneNumber = schoolTelObject
            }
            
            if let websiteObject = json["website"] as? String{
                nycHighSchools.schoolWebsite = websiteObject
            }
            
            return nycHighSchools
        }
        return nil
    }
    
    /// Pass the JSON and configure to the model type
    static func fetchHsWithJsonData(_ highSchoolsData: Any) -> [HighSchools]?{
        guard let highSchoolsDictionaryArray = highSchoolsData as? [[String: Any]] else{
            return nil
        }
        var highSchoolModelArray = [HighSchools]()
        for highSchoolsDictionary in highSchoolsDictionaryArray{
            if let highSchoolModels = Utilities.getHSInfoWithJSON(highSchoolsDictionary){
                highSchoolModelArray.append(highSchoolModels)
            }
        }
        return highSchoolModelArray
    }
    
}

