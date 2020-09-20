//
//  GameViewController.swift
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

	var gameView: GameView!
    var startMenu: StartMenu!
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
	
	class func gameViewController() -> GameViewController {
		let gameView = GameViewController(nibName: "GameViewController", bundle: nil)
		let frame = UIScreen.main.bounds
		gameView.view.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
		return gameView
	}
	
    override func viewDidLoad() {
        
//		super.viewDidLoad()
/*
		//Game View作成
		let frame = UIScreen.main.bounds
        self.gameView = GameView(frame: CGRect(x: 0,y: 0,width: frame.size.width,height: frame.size.height))
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
        
        // 表示
        self.gameView.presentScene(self.startMenu)
*/
    }

	override func viewDidAppear(_ animated: Bool) {
	}
    
	
}
