//
//  HSViewController.swift
//  20210610-JigarPatel-NYCSchools
//
//  Created by Jigar Patel on 10/06/21.
//

import UIKit
import MapKit
import ViewAnimator

class HSViewController: UIViewController {
    
    // Outlets
    @IBOutlet var schoolTableView: UITableView!
    
    var hsList: [HighSchools]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingOverlay.shared.showOverlay(view: self.view)
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchHighSchoolInformation()
        }
    }
    
    //MARK: - Fetch API and parse JSON payloads
    // we can use library like almofire to make work faster and easier
    private func fetchHighSchoolInformation(){
        guard let highSchoolsURL = URL(string: Constants.highSchoolsURL) else {
            return
        }
        
        let request = URLRequest(url:highSchoolsURL)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { [weak self] (highSchoolsData, response, error)  in
            if highSchoolsData != nil{
                do{
                    let highSchoolsObject = try JSONSerialization.jsonObject(with: highSchoolsData!, options: [])
                    self?.hsList = Utilities.fetchHsWithJsonData(highSchoolsObject)
                    self?.fetchHighSchoolSATSore()
                }catch{
                    print("Error: \(error.localizedDescription)")
                    LoadingOverlay.shared.hideOverlayView()
                }
            }
        }
        task.resume()
    }
    
    private func fetchHighSchoolSATSore(){
        guard let highSchoolsSATURL = URL(string: Constants.schoolSATURL) else {
            return
        }
        let requestForSATScore = URLRequest(url:highSchoolsSATURL)
        let session = URLSession.shared
        let task = session.dataTask(with: requestForSATScore) {[weak self] (schoolsWithSATScoreData, response, error) in
            if schoolsWithSATScoreData != nil{
                do{
                    let satScoreObject = try JSONSerialization.jsonObject(with: schoolsWithSATScoreData!, options: [])
                    self?.addSatScoreToHighSchool(satScoreObject)
                    LoadingOverlay.shared.hideOverlayView()
                    DispatchQueue.main.async {[weak self] in
                        self?.schoolTableView.reloadData()
                    }
                }catch{
                    debugPrint("high school with sat score json error: \(error.localizedDescription)")
                    LoadingOverlay.shared.hideOverlayView()
                }
            }
        }
        task.resume()
    }
    
    /// This function is used to add the sat score to the high school
    private func addSatScoreToHighSchool(_ satScoreObject: Any){
        guard let highSchoolsWithSatScoreArr = satScoreObject as? [[String: Any]] else{
            return
        }
        
        for  highSchoolsWithSatScore in highSchoolsWithSatScoreArr{
            if let matchedDBN = highSchoolsWithSatScore["dbn"] as? String{
                //This will get the High School with the Common DBN
                let matchedHighSchools = self.hsList?.first(where: { (nycHighSchool) -> Bool in
                    return nycHighSchool.dbn == matchedDBN
                })
                
                guard matchedHighSchools != nil else{
                    continue
                }
                
                if let satReadingScoreObject =  highSchoolsWithSatScore["sat_critical_reading_avg_score"] as? String{
                    matchedHighSchools!.satCriticalReadingAvgScore = satReadingScoreObject
                }
                
                if let satMathScoreObject = highSchoolsWithSatScore["sat_math_avg_score"] as? String{
                    matchedHighSchools!.satMathAvgScore = satMathScoreObject
                }
                
                if let satWritingScoreObject =  highSchoolsWithSatScore["sat_writing_avg_score"] as? String{
                    matchedHighSchools!.satWritinAvgScore = satWritingScoreObject
                }
                
            }
        }
    }
    
    // MARK: Selector Functions
    
    @objc func callNumber(_ sender: UIButton){
        
        var highSchoolList: HighSchools
        highSchoolList = self.hsList![sender.tag]
   
        let schoolPhoneNumber = highSchoolList.schoolTelephoneNumber
        
        if let url = URL(string: "tel://\(String(describing: schoolPhoneNumber))"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            let alertView = UIAlertController(title: "Error!", message: "Please run on a real device to call \(schoolPhoneNumber!)", preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertView.addAction(okayAction)
            
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    @objc func navigateToAddress(_ sender: UIButton){
        
        var highSchoolList: HighSchools
        highSchoolList = self.hsList![sender.tag]
 
        let schoolAddress = highSchoolList.schoolAddress
        
        if let highSchoolCoordinate = Utilities.getCoodinateForSelectedHighSchool(schoolAddress){
            let coordinate = CLLocationCoordinate2DMake(highSchoolCoordinate.latitude, highSchoolCoordinate.longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = "\(highSchoolList.schoolName!)"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pass the selected school with sat score to the destinatiion view controller
        if segue.identifier == Constants.HSSATScoreSegue{
            let highSchoolSATScoreVC = segue.destination as! HSDetailTableViewController
            if let highSchoolSATScore = sender as? HighSchools {
                highSchoolSATScoreVC.HSWithSatScore = highSchoolSATScore
            }
        }
    }
    
}

// MARK: UITableViewDataSource and UITableViewDelegate Extensions
extension HSViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        CellAnimator.animate(cell, withDuration: 0.6, animation: CellAnimator.AnimationType(rawValue: 5)!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HSTableViewCell = self.schoolTableView.dequeueReusableCell(withIdentifier: Constants.hsCellIdentifier, for: indexPath) as! HSTableViewCell
        
        tableView.rowHeight = 195
        
        var nycHighSchoolList: HighSchools
        nycHighSchoolList = self.hsList![indexPath.row]
       
        if let schoolName = nycHighSchoolList.schoolName {
            cell.schoolNameLbl.text = schoolName
        }
        
        if let schoolAddr = nycHighSchoolList.schoolAddress {
            let address = Utilities.getCompleteAddressWithoutCoordinate(schoolAddr)
            cell.schoolAddrLbl.text = "Address: \(address)"
            
            cell.navigateToAddrBtn.tag = indexPath.row
            cell.navigateToAddrBtn.addTarget(self, action: #selector(self.navigateToAddress(_:)), for: .touchUpInside)
        }
        
        if let phoneNum = nycHighSchoolList.schoolTelephoneNumber{
            cell.schoolPhoneNumBtn.setTitle("Phone # \(phoneNum)", for: .normal)
            
            cell.schoolPhoneNumBtn.tag = indexPath.row
            cell.schoolPhoneNumBtn.addTarget(self, action: #selector(self.callNumber(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    //MARK: - UITable View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var highSchoolList: HighSchools
        highSchoolList = self.hsList![indexPath.row]

        let selectedHighSchool = highSchoolList
        self.performSegue(withIdentifier: Constants.HSSATScoreSegue, sender: selectedHighSchool)
    }
}

