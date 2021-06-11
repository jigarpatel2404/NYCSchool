//
//  DetailCells.swift
//  20210610-JigarPatel-NYCSchools
//
//  Created by Jigar Patel on 10/06/21.
//

import Foundation
import UIKit

class DetailCells {
    /// This function get the selected High School name's  average sat scores
    
    static func tableViewCellWithSATScore(_ tableView: UITableView, HSWithSatScore: HighSchools) -> UITableViewCell{
        let schoolWithSATScoresCell = tableView.dequeueReusableCell(withIdentifier: DetailConstants.Cells.schoolWithSATScoreCellIdentifier) as! HSSatScoresTableViewCell
        
        schoolWithSATScoresCell.hsNameLbl.text = HSWithSatScore.schoolName
        
        // Sets the Average Score
        schoolWithSATScoresCell.satReadingAvgScoreLbl.text = (HSWithSatScore.satCriticalReadingAvgScore != nil) ?  (DetailConstants.averageSATReadingScore + HSWithSatScore.satCriticalReadingAvgScore!) : DetailConstants.noSATScoreInfomationText
        
        // Sets the Math Average Score
        schoolWithSATScoresCell.satMathAvgScoreLbl.isHidden = (HSWithSatScore.satMathAvgScore != nil) ? false : true
        schoolWithSATScoresCell.satMathAvgScoreLbl.text = (HSWithSatScore.satMathAvgScore != nil) ? (DetailConstants.averageSATMathScore + HSWithSatScore.satMathAvgScore!) : nil
        
        // Sets the Writing Average Score
        schoolWithSATScoresCell.satWritingAvgScoreLbl.isHidden =  (HSWithSatScore.satWritinAvgScore != nil) ? false : true
        schoolWithSATScoresCell.satWritingAvgScoreLbl.text = (HSWithSatScore.satWritinAvgScore != nil) ? (DetailConstants.averageSATWritingScore + HSWithSatScore.satWritinAvgScore!) : nil
        
        return schoolWithSATScoresCell
    }
    
    /// This function get the selected high school's overview
    static func tableViewCellWithOverView(_ tableView: UITableView, HSWithSatScore: HighSchools) -> UITableViewCell{
        let schoolWithOverviewCell = tableView.dequeueReusableCell(withIdentifier: DetailConstants.Cells.schoolOverviewCellIdentifier) as! HSOverviewTableViewCell
        
        schoolWithOverviewCell.hsOverviewLbl.text = HSWithSatScore.overviewParagraph
        
        return schoolWithOverviewCell
    }
    
    /// This function get the high school contact information with address, tel and website.
    static func tableViewCellWithContactInfo(_ tableView: UITableView, HSWithSatScore: HighSchools) -> UITableViewCell{
        let schoolWithContactCell = tableView.dequeueReusableCell(withIdentifier: DetailConstants.Cells.schoolWithContactCellIdentifier) as! HSContactTableViewCell
        
        schoolWithContactCell.hsAddressLbl.text = "Address: " + Utilities.getCompleteAddressWithoutCoordinate(HSWithSatScore.schoolAddress)
        schoolWithContactCell.hsPhoneLbl.text = (HSWithSatScore.schoolTelephoneNumber != nil) ? "Tel:  " + HSWithSatScore.schoolTelephoneNumber! : ""
        schoolWithContactCell.hsWebsiteLbl.text = HSWithSatScore.schoolWebsite
        
        return schoolWithContactCell
    }
    
    /// This function get the High School's location with annotaion on the map
    static func tableViewCellWithAddress(_ tableView: UITableView, HSWithSatScore: HighSchools) -> UITableViewCell{
        let schoolWithAddressCell = tableView.dequeueReusableCell(withIdentifier: DetailConstants.Cells.schoolWithAddressCellIdentifier) as! HSAddressTableViewCell
        
        if let highSchoolCoordinate = Utilities.getCoodinateForSelectedHighSchool(HSWithSatScore.schoolAddress){
            schoolWithAddressCell.addHSAnnotaionWithCoordinates(highSchoolCoordinate)
        }
        
        return schoolWithAddressCell
    }
}
