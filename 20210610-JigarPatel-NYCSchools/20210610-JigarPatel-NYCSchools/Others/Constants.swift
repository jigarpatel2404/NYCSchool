//
//  Constants.swift
//  20210610-JigarPatel-NYCSchools
//
//  Created by Jigar Patel on 10/06/21.
//

import Foundation

struct Constants {
    static let highSchoolsURL = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
    static let schoolSATURL = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"
    static let hsCellIdentifier = "hsCell"
    static let HSSATScoreSegue = "HSSATScoreSegue"
}

struct DetailConstants {
    struct Cells {
        static let schoolWithSATScoreCellIdentifier =  "HSSATScoresTableViewCell"
        static let schoolOverviewCellIdentifier = "HSOverViewTableViewCell"
        static let schoolWithAddressCellIdentifier = "HSAddressTableViewCell"
        static let schoolWithContactCellIdentifier = "HSContactTableViewCell"
    }

    
    static let noSATScoreInfomationText = "There is no SAT score information for this high school"
    static let averageSATReadingScore = "SAT Average Critical Reading Score:  "
    static let averageSATMathScore = "SAT Average Math Score:   "
    static let averageSATWritingScore = "SAT Average Writing Score:   "
}

