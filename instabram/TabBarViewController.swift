//
//  TabBarViewController.swift
//  instabram
//
//  Created by kaidong pei on 11/7/17.
//  Copyright © 2017 kaidong pei. All rights reserved.
//

import UIKit
import RevealingSplashView

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.selectedIndex = 2;
        playAd()
        btn()

        // Do any additional setup after loading the view.
    }
    
    
    func playAd(){
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "cloud")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red:0.11, green:0.56, blue:0.95, alpha:1.0))
        let window = UIApplication.shared.keyWindow
        window?.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.swingAndZoomOut
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        
    }
    func  changeView(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btn(){
        let WINDOW_HEIGHT = self.view.frame.height
        let TAB_HEIGHT = self.tabBar.frame.height
        let GRID_WIDTH = self.view.frame.width / 5
        let MARGIN_X = CGFloat(2)
        let MARGIN_Y = CGFloat(5)
        let BTN_WIDTH = TAB_HEIGHT - MARGIN_X * 2
        let BTN_HEIGHT = TAB_HEIGHT - MARGIN_Y * 2
        
        let modalView = UIView()
        modalView.frame = CGRect(x: GRID_WIDTH * 2, y: WINDOW_HEIGHT - TAB_HEIGHT, width: GRID_WIDTH, height: TAB_HEIGHT)
        self.view.addSubview(modalView)
        
        let postBtn = UIButton()
        postBtn.frame = CGRect(x: GRID_WIDTH * 2 + (GRID_WIDTH - BTN_WIDTH) / 2, y: WINDOW_HEIGHT - TAB_HEIGHT + MARGIN_Y, width: BTN_WIDTH, height: BTN_HEIGHT)
        postBtn.setBackgroundImage(UIImage(named: "post_btn"), for: UIControlState())
        self.view.addSubview(postBtn)
        
        postBtn.addTarget(self, action: #selector(TabBarViewController.postButtonClicked(_:)), for: .touchUpInside)
    }
    @objc func postButtonClicked(_ sender: UIButton) {
        let tb = storyboard?.instantiateViewController(withIdentifier: "view") as! ViewController
            self.present(tb, animated: true, completion: nil)
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
