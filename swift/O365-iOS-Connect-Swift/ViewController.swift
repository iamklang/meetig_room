//
//  ViewController.swift
//  O365-iOS-Connect-Swift
//
//  Created by Siraset Jirapatchandej on 8/26/2559 BE.
//  Copyright © 2559 Microsoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var loggedIn : Bool = false
    @IBOutlet var loginButton: UIButton!
    @IBAction func logInButtonTappad(_ sender: UIButton) {
        let authMgr = Authentication.sharedInstance
        
        if (loggedIn){
            // Logout and change the button to read "Log in"
            authMgr.logout()
            self.loginButton.setTitle("Log in", for: UIControlState.normal)
            self.loggedIn = false
        }
        else {
            // Attempt to get a token
            authMgr.getToken() {
                (authenticated: Bool, token: String) -> Void in
                
                if (authenticated) {
                    // Change the button to read "Log out"
                    NSLog("Authentication successful, token: %@", token)
                    self.loginButton.setTitle("Log out", for: UIControlState.normal)
                    self.loggedIn = true
                }
                else {
                    NSLog("Authentication failed: %@", token)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
