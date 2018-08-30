//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//
//import LGSideMenuController
//import AlamofireImage

import UIKit
import Foundation

class LeftViewController: UITableViewController {

   
    
    private let titlesArray = [["img": "dashboard_menu" ,"title" : "Home"], ["img": "my_cart_menu" ,"title" : "My Cart"],["img": "order_history" ,"title" : "Order History"],["img": "my_profile_menu" ,"title" : "My Profile"],["img": "change_password" ,"title" : "Change Password"],["img": "policy_menu" ,"title" : "Privacy Policy"],["img": "logout" ,"title" : "Logout"]]
    
    init() {
        super.init(style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.hexStringToUIColor(hex: "292929")
        
        registerNotifications()
        
        // view.backgroundColor = .clear
        // self.tableView.sectionHeaderHeight = 70
        // tableView.register(LeftViewCell.self, forCellReuseIdentifier: "cell")
        // tableView.separatorStyle = UIColor.lightGray
        // tableView.contentInset = UIEdgeInsets(top: 44.0, left: 0.0, bottom: 44.0, right: 0.0)
        // tableView.showsVerticalScrollIndicator = false
        // tableView.backgroundColor = .clear
        //tableView.separatorColor = UIColor(red: 250.0/255.0, green: 80.0/255.0, blue: 41.0/255.0, alpha: 1.0)
    }
    
    deinit {
        self.unregisterNotifications()
    }
    
    // ----------------------------------
    //  MARK: - Notifications -
    //
    private func registerNotifications() {
        //NotificationCenter.default.addObserver(self, selector: #selector(updateMyProfile(_:)), name: Notification.Name.UpdateMyProfile, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func updateMyProfile(_ notification: Notification) {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
       self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    
    func buttonAction(_ sender: UIButton!) {
        print("Button tapped")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
   //  MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==1 {
            return titlesArray.count
        }
        return 1
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180
        }
       /*
        if "\(UserDefaults_FindData(keyName: UserGUID))" == "" {
            if indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 6 {
                return 0
            }
        }
        */
        return 45
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //-----------User Profile---------------
        if indexPath.section == 0 {
            let CellIdentifier = "Cell"
            var cell = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier)) as? LeftProfileTopCell
            if cell == nil {
                var nib = Bundle.main.loadNibNamed("LeftProfileTopCell", owner: self, options: nil)
                cell = nib?[0] as? LeftProfileTopCell
            }
           /* if "\(UserDefaults_FindData(keyName: UserGUID))" != "" {
                let strName =  (UserDefaults_FindData(keyName: kFName) as! String)  +  " "  +  (UserDefaults_FindData(keyName: kLName) as! String)
                cell?.lblUserName.text = strName
            }else {
                cell?.lblUserName.text = "@Login"
            }
            
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: (cell?.imgProfile.frame.size)!,radius: (cell?.imgProfile.frame.size.width)! / 2)
            //cell?.imgProfile.af_setImage(withURL: URL(string: appDelegate.user.profilePicURL)!,placeholderImage: #imageLiteral(resourceName: "Logo"),filter: filter,imageTransition: .crossDissolve(0.2))
        
            cell?.btnProfile.addTarget(self, action: #selector(ClickONProfile), for: .touchUpInside)
            cell?.tag = 111;*/
            return cell!
        }

        
        
        //-----------Other Item---------------
        if indexPath.section != 0 {
            let CellIdentifier = "Cell"
            var cell = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier)) as? LeftProfileTopCell
            if cell == nil {
                var nib = Bundle.main.loadNibNamed("LeftCell", owner: self, options: nil)
                cell = nib?[0] as? LeftProfileTopCell
            }
            
            
            let dict = titlesArray[indexPath.row] as NSDictionary
            cell?.imgIcon.image = UIImage.init(named: dict["img"] as! String)
            cell?.lblTitle.text = dict["title"] as? String
            
            return cell!
        }
        
        return UITableViewCell()
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  self.rootVC_bySelection(indexPath: indexPath)
    }
 
   /*
    
    func rootVC_bySelection(indexPath: IndexPath) {
        
        if indexPath.section == 0 {//UserProfile
            
            if "\(UserDefaults_FindData(keyName: UserGUID))" == "" {
                self.isLogin()
            }
            return
            
            
        }else if indexPath.row == 0 {//Dashboard
            self.hideLeftViewAnimated(Any?)
          /*  let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CollectionsViewController") as! CollectionsViewController
            let navigationController = NavigationController(rootViewController: viewController)
            let mainViewController = MainViewController()
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type: UInt(2))
            appDelegate.window?.rootViewController = mainViewController*/
            
        }else if indexPath.row == 1 {//My Cart
            self.hideLeftViewAnimated(Any?.self)
            let cartController = mainStoryboard.instantiateViewController(withIdentifier: "CartNavigationController")
            self.present(cartController, animated: true, completion: nil)
            
        }else if indexPath.row == 2 {//Order History
            self.hideLeftViewAnimated(Any?.self)
            let cartController = mainStoryboard.instantiateViewController(withIdentifier: "OrderVC") as! OrderVC
            self.present(cartController, animated: true, completion: nil)
            
        }else if indexPath.row == 3 {//My Profile
            self.hideLeftViewAnimated(Any?.self)
            let cartController = mainStoryboard.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
            self.present(cartController, animated: true, completion: nil)

        }else if indexPath.row == 4 {//Change Password
            self.hideLeftViewAnimated(Any?.self)
            let cartController = mainStoryboard.instantiateViewController(withIdentifier: "ChangePassVC") as! ChangePassVC
            self.present(cartController, animated: true, completion: nil)
            
        }else if indexPath.row == 5 {//Privacy Policy
            self.hideLeftViewAnimated(Any?.self)
            let cartController = mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            cartController.getURL = URL(string: PrivacyPolicyURL)
            cartController.getTitle = "Privacy Policy"

            self.present(cartController, animated: true, completion: nil)
            
        }else if indexPath.row == 6 {//Logout
            isLOgout()
        }
    }
    
 
    
    
    func isLOgout(){
        let alertController = UIAlertController(title: "Logout", message: "Are you sure want to logout?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in
            
            

            DispatchQueue.main.async() {
                let iCount = CartController.shared.items.count
                for i in 0..<iCount {
                    print("----\(i)----\(iCount)----------")
                    CartController.shared.removeAllQuantitiesFor(CartController.shared.items[0])
                }
                
                if "\(UserDefaults_FindData(keyName: kDeviceToken))" != "" {
                    let token = UserDefaults_FindData(keyName: kDeviceToken)
                    if let appDomain = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    }
                    UserDefaults_SaveData(dictData: token, keyName: kDeviceToken)
                }
            }
       
            self.isLogin()

        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    fileprivate func isLogin() {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navigationController = UINavigationController(rootViewController: vc)
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
        navigationController.setNavigationBarHidden(true, animated: true)

    }
 */
}



//MARK: UIImagePickerControllerDelegate

//MARK:

extension LeftViewController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
 
    
    func ClickONProfile() {
        
        let camera = DSCameraHandler(delegate_: self)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
            camera.getCameraOn(self, canEdit: true)
        }
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoLibraryOn(self, canEdit: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
//        let indexPath = IndexPath(row: 0, section:0)
//        let cell = self.tableView.cellForRow(at: indexPath) as! LeftProfileTopCell
//        cell.imgProfile.image = image;
        // image is our desired image
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //-----------User info Update------------
    func userSettingUpdate(imgURL: String){
//        let dict =  (UserDefaults_FindData(keyName: USER_INFO) as! NSDictionary).mutableCopy() as! NSMutableDictionary
//        dict.setValue(imgURL, forKey: "ProfilePic")
//        print(dict)
//        UserDefaults_SaveData(dictData: dict, keyName: USER_INFO)
//        appDelegate.user = User(dict: dict)
//        print(appDelegate.user.profilePicURL)
//        self.tableView.reloadData()
//        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: (cell?.imgProfile.frame.size)!,radius: (cell?.imgProfile.frame.size.width)! / 2)
//        cell?.imgProfile.af_setImage(withURL: URL(string: appDelegate.user.profilePicURL)!,placeholderImage: #imageLiteral(resourceName: "Logo"),filter: filter,imageTransition: .crossDissolve(0.2))
    }
}



