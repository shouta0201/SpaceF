//
//  ViewController.swift
//  SKGameSample
//
//  Created by 北村 真二 on 2016/01/06.
//  Copyright © 2016年 STUDIO SHIN. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GameKit

class ViewController: UIViewController,UIAlertViewDelegate,GADBannerViewDelegate {

    var gameView: GameView!
    var startMenu: StartMenu!
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

    // AdMob ID を入れてください
    let AdMobID = "ca-app-pub-3863821336817317/4030222787"
    
    let TEST_ID = "ca-app-pub-3940256099942544/2934735716"
    
    let AdMobTest:Bool = false

    //Interstitial広告
    var interstitial: GADInterstitial!

    
	override func viewDidLoad() {
		super.viewDidLoad()
        

        //////////////////////////////////////////////////////
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        
        var admobView = GADBannerView()
        
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - admobView.frame.height)
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
        
        if AdMobTest {
            admobView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        }
        else{
            admobView.adUnitID = AdMobID
        }
        
        admobView.rootViewController = self
        admobView.load(GADRequest())
        /////////////////////////////////////////////////
        self.view.addSubview(admobView)
        
        appDelegate.admobheight = admobView.frame.height
        
        //自身をDelegateに渡す
        appDelegate.viewController = self
        self.interstitial = createAndLoadInterstitial()
        
        //////////////////////////////////////////////////////
        //Game View作成
        let frame = UIScreen.main.bounds
        self.gameView = GameView(frame: CGRect(x: 0,y: 0,width: frame.size.width,height: frame.size.height - appDelegate.admobheight ))

        self.gameView.allowsTransparency = true
        self.gameView.ignoresSiblingOrder = true
        self.view.addSubview(self.gameView)
        self.view.sendSubview(toBack: self.gameView)
        // Start Menu作成
        self.startMenu = StartMenu()
        self.startMenu.scaleMode = .aspectFill
        
        //画面を機種のサイズに合わせる iphone6を基準にしてscaleを設定
        appDelegate.scaleSize = 375.0 / frame.size.width
        self.startMenu.size = CGSize(width: frame.size.width * appDelegate.scaleSize, height: frame.size.height * appDelegate.scaleSize)
        self.gameView.presentScene(self.startMenu)
        
    }

    func interstitialDidDismissScreen() {
        self.interstitial = createAndLoadInterstitial()
    }
    
    func createAndLoadInterstitial() -> GADInterstitial{
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3863821336817317/9937155583")
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        interstitial.load(request)
        return interstitial
    }
    
    
    func alertView() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
        // Give user the option to start the next game.
    }
    
    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    //Game Center
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController){
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }


	override var prefersStatusBarHidden : Bool {
		return true
	}
	
}

