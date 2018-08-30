//
//  CaloriesCounterVC.swift
//  DietApp
//
//  Created by user on 03/07/18.
//  Copyright © 2018 Amit Patel. All rights reserved.
//

import UIKit
import HealthKit
import CircleProgressBar

class CaloriesCounterVC: UIViewController {

    @IBOutlet weak var circleProgressBar: CircleProgressBar!
    @IBOutlet weak var circleProgressBar1: CircleProgressBar!

    @IBOutlet weak var lblCal: UILabel!
    @IBOutlet weak var lblDist: UILabel!
    @IBOutlet weak var lblGlass: UILabel!
    @IBOutlet weak var lblSteps: UILabel!
    @IBOutlet weak var lblCalMsg: UILabel!
    @IBOutlet weak var lblDistMsg: UILabel!
    @IBOutlet weak var lblGlassMsg: UILabel!
    @IBOutlet weak var lblStepsMsg: UILabel!
    @IBOutlet weak var lblTitleMsg: UILabel!
    
    var healthStore = HKHealthStore()
    var isGetCalories = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        settings()
        readRequest()
    }
    
    private func settings(){
        lblTitleMsg.text = Localization("STEPS_COUNTER_VC")
        lblCalMsg.text = Localization("CAL_MSG")
        lblDistMsg.text = Localization("DISTANCE_MSG")
        lblGlassMsg.text = Localization("GLASSES_MSG")
        lblStepsMsg.text = Localization("STEPS_MSG")
                
        let circlePrigressBarItem11 = CircleProgressBarItem(1.0, strokeWidth: 5, strokeColor: UIColor.black)
        circleProgressBar1.animationTimeDuring = 0
        circleProgressBar1.startAngle = 270
        circleProgressBar1.sortOrder = .descending
        circleProgressBar1.add(circlePrigressBarItem11)
        circleProgressBar1.show()

        //let circlePrigressBarItem1 = CircleProgressBarItem(40.0 / 60.0, strokeWidth: 15, strokeColor:UIColor.hexStringToUIColor(hex: "469839"))
     
        circleProgressBar.startAngle = 270
        circleProgressBar.animationTimeDuring = 0.8
        circleProgressBar.sortOrder = .descending
       // circleProgressBar.add(circlePrigressBarItem1)
        circleProgressBar.show()
        
        //Language setup
        let CurrentLanguage = UserDefaults_FindData(keyName: APP_LANGUAGE) as! String
        let isEnglishLang: Bool = CurrentLanguage == LanguageSetting.en.rawValue
        let viewHeader = self.view.viewWithTag(11)
        viewHeader?.semanticContentAttribute = isEnglishLang ? .forceLeftToRight : .forceRightToLeft
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Action
    @IBAction func action_back(){
        navigationController?.popViewController(animated: true)
    }
    
    func readRequest() {
   
        guard HKHealthStore.isHealthDataAvailable() else {
            return}
        
        let readDataTypes: Set<HKObjectType> = self.dataTypesToRead()
        //let typestoShare = Set([HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!])
        
        self.healthStore.requestAuthorization(toShare: nil, read: readDataTypes) { (sucess, error) -> Void in
            
            if sucess == false {
                print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error). If you're using a simulator, try it on a device.")
            }else{
 
                self.todayTotalSteps(completion: { (iCount) in
                    
                    let circlePrigressBarItem1 = CircleProgressBarItem(CGFloat(iCount/450), strokeWidth: 15, strokeColor:UIColor.hexStringToUIColor(hex: "469839"))
                    self.circleProgressBar.add(circlePrigressBarItem1)
                    self.circleProgressBar.show()
                    
                    self.lblSteps.text = "\(iCount)"
                    self.lblDist.text = "\(self.distanse(steps: iCount))"
                    self.lblGlass.text = "\(self.recommendedGlasses())"
                    self.lblCal.text = "\(self.burnedCalories(steps: iCount))"
                })
            }
        }
    }
    
    private func dataTypesToRead() -> Set<HKObjectType> {
        let readDataTypes: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!]
        return readDataTypes
    }
  
    func todayTotalSteps(completion: @escaping (Double) -> Void) {
        
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            
            var resultCount = 0.0
            guard let result = result else {
                print("\(String(describing: error?.localizedDescription)) ")
                completion(resultCount)
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        healthStore.execute(query)
    }
    
   
    
    
    //Distance by steps
    func distanse(steps: Double)-> Double {
        var distance: Double = 0 ;
        var iLength: CGFloat = 0;
        
        if let doubleValue = Double("\(userDataModel?.height ?? "")") {
             iLength = CGFloat(doubleValue)
            if (iLength >= 5.5) {
                distance = steps * 0.000804;
            } else if (iLength >= 5.5 && iLength <= 5.11) {
                distance = steps * 0.000731;
            } else {
                distance = steps * 0.000731;
            }
   
            let x = distance
            let finalDistance = Double(round(10*x)/10)
            return finalDistance
        }
        return 0.0
    }
    
    
    func burnedCalories(steps: Double)->Double {

        var calburn: Double = 0
        if let valueHeight = Double("\(userDataModel?.height ?? "")") {
            let iLength = CGFloat(valueHeight)
            if let iWeight = Double("\(userDataModel?.weight ?? "")") {
                
                if (iLength >= 180) {
                    calburn = iWeight / 2000 * steps;
                    calburn = calburn + calburn * 20 / 100;
                } else if (iLength >= 165 && iLength <= 179) {
                    calburn = iWeight / 2000 * steps;
                    calburn = calburn + calburn * 10 / 100;
                } else {
                    calburn = (iWeight / 2000) * steps;
                }
                
                let x = calburn
                let finalDistance = Double(round(10*x)/10)
                return finalDistance
            }
        }
        return calburn
    }
    
    
    
    func recommendedGlasses()-> Int{
        var ounce: Int = 0
        if let iWeight = Double("\(userDataModel?.weight ?? "")") {
            
            let weight_pounds = iWeight * 2.20462;
            
            if (weight_pounds <= 100) {
                ounce = 67;
            } else if (weight_pounds >= 110 && weight_pounds <= 120) {
                ounce = 74;
            } else if (weight_pounds >= 120 && weight_pounds <= 130) {
                ounce = 80;
            } else if (weight_pounds >= 130 && weight_pounds <= 140) {
                ounce = 87;
            } else if (weight_pounds >= 140 && weight_pounds <= 150) {
                ounce = 94;
            } else if (weight_pounds >= 150 && weight_pounds <= 160) {
                ounce = 100;
            } else if (weight_pounds >= 160 && weight_pounds <= 170) {
                ounce = 107;
            } else if (weight_pounds >= 170 && weight_pounds <= 180) {
                ounce = 114;
            } else if (weight_pounds >= 180 && weight_pounds <= 190) {
                ounce = 121;
            } else if (weight_pounds >= 190 && weight_pounds <= 200) {
                ounce = 127;
            } else if (weight_pounds >= 200 && weight_pounds <= 210) {
                ounce = 134;
            } else if (weight_pounds >= 210 && weight_pounds <= 220) {
                ounce = 141;
            } else if (weight_pounds >= 220 && weight_pounds <= 230) {
                ounce = 148;
            } else if (weight_pounds >= 230 && weight_pounds <= 240) {
                ounce = 154;
            } else if (weight_pounds >= 240 && weight_pounds <= 250) {
                ounce = 161;
            } else {
                ounce = 168;
            }
            
            let intake = ounce / 8
            return intake
        }
        return ounce
    }
    
    
    
    
}


extension CaloriesCounterVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CaloriesCounterCell
            
            cell.lblQuan.text = isGetCalories
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! CaloriesCounterCell
            
            cell.lblQuan.text = "0"
            return cell
            
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! CaloriesCounterCell
            
            cell.lblQuan.text = "0"
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! CaloriesCounterCell
            
            let isWaterIntake = UserDefaults_FindData(keyName: RECOMMENDED_WATER_INTAKE) as! String
            if isWaterIntake != "" {
                let isUpToSelection = NSInteger(isWaterIntake)!
                cell.lblQuan.text = "\(isUpToSelection + 1)"
            }else{
                cell.lblQuan.text = "0"
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "RecommendedWaterVC") as! RecommendedWaterVC
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
