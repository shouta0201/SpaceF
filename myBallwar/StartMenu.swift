//
//  StartMenu.swift
//  myBallwar
import Foundation

import UIKit
import SpriteKit
import AVFoundation
import GameKit

class StartMenu: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate,GKGameCenterControllerDelegate {

    let gsCore = GameSceneController()
    var audioPlayer:AVAudioPlayer!
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let player1 = GamePlayer()
    let status1 = GameStatus()
    
    let baseNode = SKNode()						//ゲームベースノード
    let selectNode = SKNode()					//セレクトノード
    let ZankiIcon = SKSpriteNode()
    
    let backScrNode = SKNode()					//背景ノード
    var allScreenSize = CGSize(width: 0, height: 0)	//全画面サイズ
    var oneScreenSize = CGSize(width: 0, height: 0)	//１画面サイズ
    
    var tapPoint: CGPoint = CGPoint.zero
    var tapEndPoint: CGPoint = CGPoint.zero
    var screenSpeed: CGFloat = 12.0
    var screenSpeedScale: CGFloat = 1.0
    
    var start_Label: SKLabelNode!
    var back_Label: SKLabelNode!
    var Ranking_Label: SKLabelNode!
    var normal_Label: SKLabelNode!
    var hard_Label: SKLabelNode!
    var start_button: SKShapeNode!
    var how_to_play: SKLabelNode!

    var stage001: SKLabelNode!
    var stage002: SKLabelNode!
    var stage003: SKLabelNode!
    var stage004: SKLabelNode!
    var stage005: SKLabelNode!
    var stage006: SKLabelNode!
    var stage007: SKLabelNode!
    var stage008: SKLabelNode!
    var stage009: SKLabelNode!
    var stage00F: SKLabelNode!
    var debugFlag: SKShapeNode!
    
    let leaderboardIdentifier = "shouta.0201@ezweb.ne.jp"
    
    //タッチエンド
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player1.tapping = false
        var location: CGPoint!
        for touch in touches {
            location = touch.location(in: self)
        }
        let touchNode = atPoint(location)

        //TAP START BUTTON
        if touchNode.name == "start_Label"
        {
            ////Start Scene////////////////////////////////////
            self.start_Label.run(SKAction.fadeOut(withDuration: 0.01))
            self.how_to_play.run(SKAction.fadeOut(withDuration: 0.01))
            viewModeSelect()
            
            //テスト
//            reportScore(value: 50, leaderboardId: "shouta.0201@ezweb.ne.jp")

        }
        //NORMAL BUTTON
        if touchNode.name == "normal_Label"
        {
            appDelegate.gameMode = "normal"
            self.normal_Label.run(SKAction.fadeOut(withDuration: 0.5))
            self.hard_Label.run(SKAction.fadeOut(withDuration: 0.5))
            viewStageSelect_normal()
        }
        //HARD BUTTON
        if touchNode.name == "hard_Label"
        {
            ///HARD MODE ON/////////////////////////////////////
            appDelegate.gameMode = "hard"
            self.normal_Label.run(SKAction.fadeOut(withDuration: 0.5))
            self.hard_Label.run(SKAction.fadeOut(withDuration: 0.5))
            viewStageSelect()
        }
        //BACK BUTTON
        if touchNode.name == "back_Label"
        {
            let scene = StartMenu(size: CGSize(width: frame.size.width , height: frame.size.height ))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(scene, transition: transition)

        }
        
        //Ranking BUTTON
        if touchNode.name == "Ranking_Labelaaaaaaaaaaaaaa"
        {
            print("Ranking BUTTON")
            let localPlayer = GKLocalPlayer()
            localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifier : String?, error : NSError?) -> Void in
                if error != nil {
                    //print(error?.localizedDescription)
                    print("error?")
                } else {
                    print("Ranking 2")
                    let gcViewController: GKGameCenterViewController = GKGameCenterViewController()
                    gcViewController.gameCenterDelegate = self as? GKGameCenterControllerDelegate
                    gcViewController.viewState = GKGameCenterViewControllerState.leaderboards
                    gcViewController.leaderboardIdentifier = "shouta.0201@ezweb.ne.jp"
                    
//                  self.presentView(gcViewController, animated: true, completion: nil)
                    self.appDelegate.viewController.present(gcViewController, animated: true, completion: nil)
                }
                print("Ranking 3")
            } as? (String?, Error?) -> Void)

            print("Ranking 4")
        }

        
        //HOW TO PLAY
        if touchNode.name == "how_to_play"
        {
            let scene = HowToPlay(size: CGSize(width: frame.size.width , height: frame.size.height ))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.moveIn(with: SKTransitionDirection.down, duration: 1)
            self.view!.presentScene(scene, transition: transition)
        }
        if touchNode.name == "stage001"
        {
            appDelegate.audioPlayer.stop()
            self.appDelegate.zankiSuu = gsCore.initZankisuu
            let scene = Stage001(size: CGSize(width: frame.size.width , height: frame.size.height ))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1)
            self.view!.presentScene(scene, transition: transition)
        }
        if touchNode.name == "stage002"
        {
            appDelegate.audioPlayer.stop()
            self.appDelegate.zankiSuu = gsCore.initZankisuu
            let scene = Stage002(size: CGSize(width: frame.size.width , height: frame.size.height ))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1)
            self.view!.presentScene(scene, transition: transition)
        }
        if touchNode.name == "stage003"
        {
            appDelegate.audioPlayer.stop()
            self.appDelegate.zankiSuu = gsCore.initZankisuu
            let scene = Stage003(size: CGSize(width: frame.size.width , height: frame.size.height ))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1)
            self.view!.presentScene(scene, transition: transition)
        }
        if touchNode.name == "stage004"
        {
            appDelegate.audioPlayer.stop()
            self.appDelegate.zankiSuu = gsCore.initZankisuu
            let scene = Stage004(size: CGSize(width: frame.size.width , height: frame.size.height ))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1)
            self.view!.presentScene(scene, transition: transition)
        }
        if touchNode.name == "stage005"
        {
            appDelegate.audioPlayer.stop()
            self.appDelegate.zankiSuu = gsCore.initZankisuu
            let scene = Stage005(size: CGSize(width: frame.size.width , height: frame.size.height ))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1)
            self.view!.presentScene(scene, transition: transition)
        }
        if touchNode.name == "stage006"
        {
            appDelegate.audioPlayer.stop()
            self.appDelegate.zankiSuu = gsCore.initZankisuu
            let scene = Stage006(size: CGSize(width: frame.size.width , height: frame.size.height ))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1)
            self.view!.presentScene(scene, transition: transition)
        }
        if touchNode.name == "stage007"
        {
            appDelegate.audioPlayer.stop()
            self.appDelegate.zankiSuu = gsCore.initZankisuu
            let scene = Stage007(size: CGSize(width: frame.size.width , height: frame.size.height ))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1)
            self.view!.presentScene(scene, transition: transition)
        }
        if touchNode.name == "stage008"
        {
            appDelegate.audioPlayer.stop()
            self.appDelegate.zankiSuu = gsCore.initZankisuu
            let scene = Stage008(size: CGSize(width: frame.size.width , height: frame.size.height ))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1)
            self.view!.presentScene(scene, transition: transition)
        }
        if touchNode.name == "stage009"
        {
            appDelegate.audioPlayer.stop()
            self.appDelegate.zankiSuu = gsCore.initZankisuu
            let scene = Stage009(size: CGSize(width: frame.size.width , height: frame.size.height ))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1)
            self.view!.presentScene(scene, transition: transition)
        }
        if touchNode.name == "stage00F"
        {
            appDelegate.audioPlayer.stop()
            self.appDelegate.zankiSuu = gsCore.initZankisuu
            let scene = Stage00F(size: CGSize(width: frame.size.width , height: frame.size.height ))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1)
            self.view!.presentScene(scene, transition: transition)
        }
        //debug
        if touchNode.name == "debugFlag"
        {
            debugFlag.removeFromParent()
            appDelegate.debugFlag = true
            
        }
    }
    
    //
    func reportScore(value: Int, leaderboardId: String) {
        let score: GKScore = GKScore()
        score.value = Int64(value)
        score.leaderboardIdentifier = leaderboardId
        let scoreArr:[GKScore] = [score]
        GKScore.report(scoreArr, withCompletionHandler:{(error:NSError!) -> Void in
            if((error != nil)) {
                print("ReportScore: Error")
            } else {
                print("ReportScore: Success")
            }
            } as? (Error?) -> Void)
    }

    //Game Center
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController){
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }


    func viewModeSelect(){
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "normal_Label", using: { (node, stop) -> Void in
                self.normal_Label = node as! SKLabelNode
                self.normal_Label.removeFromParent()
                self.normal_Label.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.normal_Label.run(act)
                self.selectNode.addChild(self.normal_Label)
                
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "hard_Label", using: { (node, stop) -> Void in
                self.hard_Label = node as! SKLabelNode
                self.hard_Label.removeFromParent()
                self.hard_Label.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.hard_Label.run(act)
                self.selectNode.addChild(self.hard_Label)
                
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "back_Label", using: { (node, stop) -> Void in
                self.back_Label = node as! SKLabelNode
                self.back_Label.removeFromParent()
                self.back_Label.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.back_Label.run(act)
                self.selectNode.addChild(self.back_Label)
                
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "Ranking_Labelaaaaaaaaaaaaaa", using: { (node, stop) -> Void in
                self.Ranking_Label = node as! SKLabelNode
                self.Ranking_Label.removeFromParent()
                self.Ranking_Label.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.Ranking_Label.run(act)
                self.selectNode.addChild(self.Ranking_Label)
                
            })
        }
        
        //Complete Label
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "complete", using: { (node, stop) -> Void in
                self.back_Label = node as! SKLabelNode
                self.back_Label.removeFromParent()
                self.back_Label.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.back_Label.run(act)
                self.selectNode.addChild(self.back_Label)
                
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "parsent", using: { (node, stop) -> Void in
                self.back_Label = node as! SKLabelNode
                self.back_Label.removeFromParent()
                self.back_Label.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.back_Label.run(act)
                self.selectNode.addChild(self.back_Label)
                
            })
        }
        
        gsCore.calcCompRate()
        
        //
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "comp_rate", using: { (node, stop) -> Void in
                self.back_Label = node as! SKLabelNode
                self.back_Label.removeFromParent()
                self.back_Label.alpha = 0.0
                self.back_Label.text = self.appDelegate.compRate
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.back_Label.run(act)
                self.selectNode.addChild(self.back_Label)
                
            })
        }
        
        
        
    }
    
    func viewStageSelect(){
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage001", using: { (node, stop) -> Void in
                self.stage001 = node as! SKLabelNode
                self.stage001.removeFromParent()
                self.stage001.name = "stage001"
                self.stage001.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage001.run(act)
                self.selectNode.addChild(self.stage001)
                
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage002", using: { (node, stop) -> Void in
                self.stage002 = node as! SKLabelNode
                self.stage002.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage002c"){
                    self.stage002.name = "stage002"
                }else{
                    self.stage002.name = "stage002n"
                    self.stage002.fontColor = UIColor.gray
                }
                self.stage002.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage002.run(act)
                self.selectNode.addChild(self.stage002)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage003", using: { (node, stop) -> Void in
                self.stage003 = node as! SKLabelNode
                self.stage003.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage003c"){
                    self.stage003.name = "stage003"
                }else{
                    self.stage003.name = "stage003n"
                    self.stage003.fontColor = UIColor.gray
                }
                self.stage003.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage003.run(act)
                self.selectNode.addChild(self.stage003)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage004", using: { (node, stop) -> Void in
                self.stage004 = node as! SKLabelNode
                self.stage004.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage004c"){
                    self.stage004.name = "stage004"
                }else{
                    self.stage004.name = "stage004n"
                    self.stage004.fontColor = UIColor.gray
                }
                self.stage004.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage004.run(act)
                self.selectNode.addChild(self.stage004)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage005", using: { (node, stop) -> Void in
                self.stage005 = node as! SKLabelNode
                self.stage005.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage005c"){
                    self.stage005.name = "stage005"
                }else{
                    self.stage005.name = "stage005n"
                    self.stage005.fontColor = UIColor.gray
                }
                self.stage005.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage005.run(act)
                self.selectNode.addChild(self.stage005)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage006", using: { (node, stop) -> Void in
                self.stage006 = node as! SKLabelNode
                self.stage006.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage006c"){
                    self.stage006.name = "stage006"
                }else{
                    self.stage006.name = "stage006n"
                    self.stage006.fontColor = UIColor.gray
                }
                self.stage006.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage006.run(act)
                self.selectNode.addChild(self.stage006)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage007", using: { (node, stop) -> Void in
                self.stage007 = node as! SKLabelNode
                self.stage007.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage007c"){
                    self.stage007.name = "stage007"
                }else{
                    self.stage007.name = "stage007n"
                    self.stage007.fontColor = UIColor.gray
                }
                self.stage007.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage007.run(act)
                self.selectNode.addChild(self.stage007)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage008", using: { (node, stop) -> Void in
                self.stage008 = node as! SKLabelNode
                self.stage008.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage008c"){
                    self.stage008.name = "stage008"
                }else{
                    self.stage008.name = "stage008n"
                    self.stage008.fontColor = UIColor.gray
                }
                self.stage008.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage008.run(act)
                self.selectNode.addChild(self.stage008)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage009", using: { (node, stop) -> Void in
                self.stage009 = node as! SKLabelNode
                self.stage009.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage009c"){
                    self.stage009.name = "stage009"
                }else{
                    self.stage009.name = "stage009n"
                    self.stage009.fontColor = UIColor.gray
                }
                self.stage009.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage009.run(act)
                self.selectNode.addChild(self.stage009)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage00F", using: { (node, stop) -> Void in
                self.stage00F = node as! SKLabelNode
                self.stage00F.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage00Fc"){
                    self.stage00F.name = "stage00F"
                }else{
                    self.stage00F.name = "stage00Fn"
                    self.stage00F.fontColor = UIColor.gray
                }
                self.stage00F.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage00F.run(act)
                self.selectNode.addChild(self.stage00F)
            })
        }
    }

    
    func viewStageSelect_normal(){
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage001", using: { (node, stop) -> Void in
                self.stage001 = node as! SKLabelNode
                self.stage001.removeFromParent()
                self.stage001.name = "stage001"
                self.stage001.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage001.run(act)
                self.selectNode.addChild(self.stage001)
                
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage002", using: { (node, stop) -> Void in
                self.stage002 = node as! SKLabelNode
                self.stage002.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage002c_normal"){
                    self.stage002.name = "stage002"
                }else{
                    self.stage002.name = "stage002n"
                    self.stage002.fontColor = UIColor.gray
                }
                self.stage002.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage002.run(act)
                self.selectNode.addChild(self.stage002)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage003", using: { (node, stop) -> Void in
                self.stage003 = node as! SKLabelNode
                self.stage003.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage003c_normal"){
                    self.stage003.name = "stage003"
                }else{
                    self.stage003.name = "stage003n"
                    self.stage003.fontColor = UIColor.gray
                }
                self.stage003.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage003.run(act)
                self.selectNode.addChild(self.stage003)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage004", using: { (node, stop) -> Void in
                self.stage004 = node as! SKLabelNode
                self.stage004.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage004c_normal"){
                    self.stage004.name = "stage004"
                }else{
                    self.stage004.name = "stage004n"
                    self.stage004.fontColor = UIColor.gray
                }
                self.stage004.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage004.run(act)
                self.selectNode.addChild(self.stage004)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage005", using: { (node, stop) -> Void in
                self.stage005 = node as! SKLabelNode
                self.stage005.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage005c_normal"){
                    self.stage005.name = "stage005"
                }else{
                    self.stage005.name = "stage005n"
                    self.stage005.fontColor = UIColor.gray
                }
                self.stage005.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage005.run(act)
                self.selectNode.addChild(self.stage005)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage006", using: { (node, stop) -> Void in
                self.stage006 = node as! SKLabelNode
                self.stage006.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage006c_normal"){
                    self.stage006.name = "stage006"
                }else{
                    self.stage006.name = "stage006n"
                    self.stage006.fontColor = UIColor.gray
                }
                self.stage006.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage006.run(act)
                self.selectNode.addChild(self.stage006)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage007", using: { (node, stop) -> Void in
                self.stage007 = node as! SKLabelNode
                self.stage007.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage007c_normal"){
                    self.stage007.name = "stage007"
                }else{
                    self.stage007.name = "stage007n"
                    self.stage007.fontColor = UIColor.gray
                }
                self.stage007.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage007.run(act)
                self.selectNode.addChild(self.stage007)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage008", using: { (node, stop) -> Void in
                self.stage008 = node as! SKLabelNode
                self.stage008.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage008c_normal"){
                    self.stage008.name = "stage008"
                }else{
                    self.stage008.name = "stage008n"
                    self.stage008.fontColor = UIColor.gray
                }
                self.stage008.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage008.run(act)
                self.selectNode.addChild(self.stage008)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage009", using: { (node, stop) -> Void in
                self.stage009 = node as! SKLabelNode
                self.stage009.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage009c_normal"){
                    self.stage009.name = "stage009"
                }else{
                    self.stage009.name = "stage009n"
                    self.stage009.fontColor = UIColor.gray
                }
                self.stage009.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage009.run(act)
                self.selectNode.addChild(self.stage009)
            })
        }
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            startMenuScene.enumerateChildNodes(withName: "stage00F", using: { (node, stop) -> Void in
                self.stage00F = node as! SKLabelNode
                self.stage00F.removeFromParent()
                if self.appDelegate.clearStageMemory.bool(forKey: "stage00Fc_normal"){
                    self.stage00F.name = "stage00F"
                }else{
                    self.stage00F.name = "stage00Fn"
                    self.stage00F.fontColor = UIColor.gray
                }
                self.stage00F.alpha = 0.0
                let act = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.fadeIn(withDuration: 0.5)
                    ])
                self.stage00F.run(act)
                self.selectNode.addChild(self.stage00F)
            })
        }
    }


    
    func allStageClear(){
        appDelegate.clearStageMemory.set(true, forKey: "stage002c")
        appDelegate.clearStageMemory.set(true, forKey: "stage003c")
        appDelegate.clearStageMemory.set(true, forKey: "stage004c")
        appDelegate.clearStageMemory.set(true, forKey: "stage005c")
        appDelegate.clearStageMemory.set(true, forKey: "stage006c")
        appDelegate.clearStageMemory.set(true, forKey: "stage007c")
        appDelegate.clearStageMemory.set(true, forKey: "stage008c")
        appDelegate.clearStageMemory.set(true, forKey: "stage009c")
        appDelegate.clearStageMemory.set(true, forKey: "stage00Fc")
        appDelegate.clearStageMemory.set(true, forKey: "stageFFFc")

        appDelegate.clearStageMemory.set(true, forKey: "stage002c_normal")
        appDelegate.clearStageMemory.set(true, forKey: "stage003c_normal")
        appDelegate.clearStageMemory.set(true, forKey: "stage004c_normal")
        appDelegate.clearStageMemory.set(true, forKey: "stage005c_normal")
        appDelegate.clearStageMemory.set(true, forKey: "stage006c_normal")
        appDelegate.clearStageMemory.set(true, forKey: "stage007c_normal")
        appDelegate.clearStageMemory.set(true, forKey: "stage008c_normal")
        appDelegate.clearStageMemory.set(true, forKey: "stage009c_normal")
        appDelegate.clearStageMemory.set(true, forKey: "stage00Fc_normal")
        appDelegate.clearStageMemory.set(true, forKey: "stageFFFc_normal")
        
    }
    
    func resetStageClear(){
        appDelegate.clearStageMemory.set(false, forKey: "stage002c")
        appDelegate.clearStageMemory.set(false, forKey: "stage003c")
        appDelegate.clearStageMemory.set(false, forKey: "stage004c")
        appDelegate.clearStageMemory.set(false, forKey: "stage005c")
        appDelegate.clearStageMemory.set(false, forKey: "stage006c")
        appDelegate.clearStageMemory.set(false, forKey: "stage007c")
        appDelegate.clearStageMemory.set(false, forKey: "stage008c")
        appDelegate.clearStageMemory.set(false, forKey: "stage009c")
        appDelegate.clearStageMemory.set(false, forKey: "stage00Fc")
        appDelegate.clearStageMemory.set(false, forKey: "stageFFFc")
    
        appDelegate.clearStageMemory.set(false, forKey: "stage002c_normal")
        appDelegate.clearStageMemory.set(false, forKey: "stage003c_normal")
        appDelegate.clearStageMemory.set(false, forKey: "stage004c_normal")
        appDelegate.clearStageMemory.set(false, forKey: "stage005c_normal")
        appDelegate.clearStageMemory.set(false, forKey: "stage006c_normal")
        appDelegate.clearStageMemory.set(false, forKey: "stage007c_normal")
        appDelegate.clearStageMemory.set(false, forKey: "stage008c_normal")
        appDelegate.clearStageMemory.set(false, forKey: "stage009c_normal")
        appDelegate.clearStageMemory.set(false, forKey: "stage00Fc_normal")
        appDelegate.clearStageMemory.set(false, forKey: "stageFFFc_normal")
    
    }
    
    //MARK: シーンが表示されたときに呼ばれる関数
    override func didMove(to view: SKView) {

        
        //■■■■■■■■■■■■■■■■■■デバッグ用ステージクリアリセットメソッド■■■■■■■■■■■
//        resetStageClear()
//        allStageClear()
  

        // 再生する音源のURLを生成
        if appDelegate.audiomusic != "opening" {
            appDelegate.audiomusic = "opening"
            appDelegate.audioSet()
            appDelegate.audioPlayer.delegate = self
            appDelegate.audioPlayer.play()
            appDelegate.audioPlayer.numberOfLoops = -1
        }

        // 再生する音源のURLを生成
/*        let soundFilePath : String = Bundle.main.path(forResource: "opening", ofType: "mp3")!
        let fileURL : URL = URL(fileURLWithPath: soundFilePath)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer.delegate = self
        }
        catch{
        }
        
        audioPlayer.play()
*/
        
        //スピード定義
        player1.speedvelocity = 200

        self.backgroundColor = SKColor.clear

        self.addChild(self.baseNode)
        self.addChild(self.backScrNode)
        self.addChild(self.selectNode)
        
        self.baseNode.physicsBody = SKPhysicsBody()
        self.baseNode.physicsBody!.affectedByGravity = false
        
        let hCount = 1		//縦の画面数
        let wCount = 1		//幅の画面数
        
        //画面サイズ
        self.oneScreenSize = UIScreen.main.bounds.size
        self.allScreenSize = CGSize(width: self.oneScreenSize.width * CGFloat(wCount) , height: self.size.width * CGFloat(hCount))
        
        
        
        //シーンファイルを読み込み
        if let startMenuScene = SKScene(fileNamed: "StartMenu.sks") {
            //DEBUGFLAG
            startMenuScene.enumerateChildNodes(withName: "debugFlag", using: { (node, stop) -> Void in
                self.debugFlag = node as! SKShapeNode
                self.debugFlag.name = "debugFlag"
                self.debugFlag.removeFromParent()
                self.selectNode.addChild(self.debugFlag)
            })
            //スタートボタン
            startMenuScene.enumerateChildNodes(withName: "start_bottun1", using: { (node, stop) -> Void in
                let start_button = node as! SKShapeNode
                self.start_button.name = "start_bottun"
                self.start_button.removeFromParent()
                self.selectNode.addChild(start_button)
            })
            //スタートラベル
            startMenuScene.enumerateChildNodes(withName: "start_Label", using: { (node, stop) -> Void in
                self.start_Label = node as! SKLabelNode
                self.start_Label.name = "start_Label"
                self.start_Label.text = "TAP TO START"
                self.start_Label.removeFromParent()
                self.selectNode.addChild(self.start_Label)
            })
            //How to play
            startMenuScene.enumerateChildNodes(withName: "how_to_play", using: { (node, stop) -> Void in
                self.how_to_play = node as! SKLabelNode
                self.how_to_play.name = "how_to_play"
//                self.how_to_play.text = "TAP TO START"
                self.how_to_play.removeFromParent()
                self.selectNode.addChild(self.how_to_play)
            })
            //app_title
            startMenuScene.enumerateChildNodes(withName: "app_title", using: { (node, stop) -> Void in
                let app_title = node as! SKLabelNode
                app_title.name = "stage_Label"
                app_title.text = "Spece F"
                app_title.removeFromParent()
                self.selectNode.addChild(app_title)
            })
            //Label
            startMenuScene.enumerateChildNodes(withName: "app_title", using: { (node, stop) -> Void in
                let app_title = node as! SKLabelNode
                app_title.name = "labels"
                app_title.removeFromParent()
                self.selectNode.addChild(app_title)

            })
            //背景
            startMenuScene.enumerateChildNodes(withName: "back_wall", using: { (node, stop) -> Void in
                let back_wall = node as! SKSpriteNode
                back_wall.name = NodeName.backGround.rawValue
                //シーンから削除して再配置
                back_wall.removeFromParent()
                self.backScrNode.addChild(back_wall)
            })
            //MARK: プレイヤー
            self.player1.charXOffset = self.oneScreenSize.width * 0.5
            self.player1.charYOffset = self.oneScreenSize.height * 0.5
            startMenuScene.enumerateChildNodes(withName: "player", using: { (node, stop) -> Void in
                let player = node as! SKSpriteNode
                self.player1.playerNode = player
                player.removeFromParent()
                //物理設定
                self.baseNode.addChild(self.player1.playerNode)
                self.player1.playerNode.physicsBody = SKPhysicsBody(circleOfRadius: 6)
                self.player1.playerNode.physicsBody!.affectedByGravity = false
                self.player1.playerNode.physicsBody!.friction = 1.0			//摩擦
                self.player1.playerNode.physicsBody!.allowsRotation = false	//回転禁止
                self.player1.playerNode.physicsBody!.restitution = 0.0		//跳ね返り値
                self.player1.playerNode.physicsBody!.categoryBitMask = NodeName.player.category()
            })
        }
    }
    
    //MARK: - タッチ処理
    //タッチダウンされたときに呼ばれる関数
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var location: CGPoint!
        for touch in touches {
            location = touch.location(in: self)
        }
        
        self.tapPoint = location
        player1.playerNode.physicsBody!.linearDamping = 0.0
        
    }
    
    
    //タッチ移動
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    //MARK: - シーンのアップデート時に呼ばれる関数
    override func update(_ currentTime: TimeInterval) {
        
        self.backScrNode.physicsBody = SKPhysicsBody()
        self.backScrNode.physicsBody?.affectedByGravity = false
        self.backScrNode.physicsBody!.velocity =  CGVector(dx: 0.0, dy: -100)
        self.backScrNode.position.x = self.backScrNode.position.x.truncatingRemainder(dividingBy: 500)
        self.backScrNode.position.y = self.backScrNode.position.y.truncatingRemainder(dividingBy: 800)
        
    }
    
    
    
    //MARK: - すべてのアクションと物理シミュレーション処理後、1フレーム毎に呼び出される
    override func didSimulatePhysics() {
    }
    
    //MARK: - 接触判定
    func didBegin(_ contact: SKPhysicsContact) {
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    
}

