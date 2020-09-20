//
//  EndingScene.swift
//  myBallwar
import Foundation

import UIKit
import SpriteKit
import AVFoundation

class EndingScene: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate {

    let gsCore = GameSceneController()

    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let player1 = GamePlayer()
    let status1 = GameStatus()
    
    let baseNode = SKNode()						//ゲームベースノード
    let endSceneNode = SKNode()					//セレクトノード
    let ZankiIcon = SKSpriteNode()
    
    let backScrNode = SKNode()					//背景ノード
    var allScreenSize = CGSize(width: 0, height: 0)	//全画面サイズ
    var oneScreenSize = CGSize(width: 0, height: 0)	//１画面サイズ
    
    var tapPoint: CGPoint = CGPoint.zero
    var tapEndPoint: CGPoint = CGPoint.zero
    var screenSpeed: CGFloat = 12.0
    var screenSpeedScale: CGFloat = 1.0
    
    var back_Label: SKLabelNode!
    var start_Label: SKLabelNode!
    var start_button: SKShapeNode!

    
    //タッチエンド
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player1.tapping = false
        var location: CGPoint!
        for touch in touches {
            location = touch.location(in: self)
        }
        let touchNode = atPoint(location)
        
        //facebook
        if touchNode.name == "icon_facebook"
        {
            gsCore.postToFacebook()
        }
        //twitter
        if touchNode.name == "icon_twitter"
        {
            gsCore.postToTwitter()
        }
        
        //Review
        if touchNode.name == "icon_star"
        {
            gsCore.postToReview()
        }

        //TAP START BUTTON
        if touchNode.name == "back_Label"
        {
            //AUDIO STOP
            appDelegate.audioPlayer.stop()
            self.appDelegate.zankiSuu = gsCore.initZankisuu
            let scene = StartMenu(size: CGSize(width: frame.size.width , height: frame.size.height ))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 3)
            self.view!.presentScene(scene, transition: transition)
        }
    }

    
    
    //MARK: シーンが表示されたときに呼ばれる関数
    override func didMove(to view: SKView) {

        //スピード定義
//        player1.speedvelocity = 400

        self.backgroundColor = SKColor.clear

        self.addChild(self.baseNode)
        self.addChild(self.backScrNode)
        self.addChild(self.endSceneNode)
        
        self.baseNode.physicsBody = SKPhysicsBody()
        self.baseNode.physicsBody!.affectedByGravity = false
        
        let hCount = 1		//縦の画面数
        let wCount = 1		//幅の画面数
        
        // 再生する音源のURLを生成
        if appDelegate.audiomusic != "Fending" {
            appDelegate.audiomusic = "Fending"
            appDelegate.audioSet()
            appDelegate.audioPlayer.delegate = self
            appDelegate.audioPlayer.numberOfLoops = -1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.appDelegate.audioPlayer.play()
            }
        }

        //画面サイズ
        self.oneScreenSize = UIScreen.main.bounds.size
        self.allScreenSize = CGSize(width: self.oneScreenSize.width * CGFloat(wCount) , height: self.size.width * CGFloat(hCount))
        
        //シーンファイルを読み込み
        if let startMenuScene = SKScene(fileNamed: "EndingScene.sks") {
            //スタートラベル
            startMenuScene.enumerateChildNodes(withName: "pass_Label", using: { (node, stop) -> Void in
                self.start_Label = node as! SKLabelNode
                self.start_Label.name = "start_Label"
//                self.start_Label.text = "T"
                self.start_Label.removeFromParent()
                self.endSceneNode.addChild(self.start_Label)
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
        
        endComment()
        
    }

    func endComment(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            if let startMenuScene = SKScene(fileNamed: "EndingScene.sks") {
                //ラベル
                startMenuScene.enumerateChildNodes(withName: "pass_Label1", using: { (node, stop) ->    Void in
                    self.start_Label = node as! SKLabelNode
                    self.start_Label.removeFromParent()
                    self.start_Label.alpha = 0.0
                    let act = SKAction.sequence([
                        SKAction.fadeIn(withDuration: 0.5),
                        SKAction.wait(forDuration: 5),
                        SKAction.fadeOut(withDuration: 0.5)
                        ])
                    self.start_Label.run(act)
                    self.endSceneNode.addChild(self.start_Label)
                })
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 16) {
            if let startMenuScene = SKScene(fileNamed: "EndingScene.sks") {
                startMenuScene.enumerateChildNodes(withName: "pass_Label2", using: { (node, stop) ->    Void in
                    self.start_Label = node as! SKLabelNode
                    self.start_Label.removeFromParent()
                    self.start_Label.alpha = 0.0
                    let act = SKAction.sequence([
                        SKAction.fadeIn(withDuration: 0.5),
                        SKAction.wait(forDuration: 11),
                        SKAction.fadeOut(withDuration: 0.5)
                        ])
                    self.start_Label.run(act)
                    self.endSceneNode.addChild(self.start_Label)
                })
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 19) {
            if let startMenuScene = SKScene(fileNamed: "EndingScene.sks") {
                startMenuScene.enumerateChildNodes(withName: "pass_Label3", using: { (node, stop) ->    Void in
                    self.start_Label = node as! SKLabelNode
                    self.start_Label.removeFromParent()
                    self.start_Label.alpha = 0.0
                    let act = SKAction.sequence([
                        SKAction.fadeIn(withDuration: 0.5),
                        SKAction.wait(forDuration: 8),
                        SKAction.fadeOut(withDuration: 0.5)
                        ])
                    self.start_Label.run(act)
                    self.endSceneNode.addChild(self.start_Label)
                })
            }
        }
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 25) {
            let path = Bundle.main.path(forResource: "warmhole", ofType: "sks")
            let particle = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
            particle.position.x = self.oneScreenSize.width / 2
            particle.position.y = self.oneScreenSize.height - 130
            particle.zPosition = 5
            self.endSceneNode.addChild(particle)

            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                let act = SKAction.sequence([
                    SKAction.fadeOut(withDuration: 2)
                    ])

                particle.run(act)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 37) {
            if let startMenuScene = SKScene(fileNamed: "EndingScene.sks") {
                startMenuScene.enumerateChildNodes(withName: "pass_Label4", using: { (node, stop) ->    Void in
                    self.start_Label = node as! SKLabelNode
                    self.start_Label.removeFromParent()
                    self.start_Label.alpha = 0.0
                    let act = SKAction.sequence([
                        SKAction.fadeIn(withDuration: 0.5),
                        ])
                    self.start_Label.run(act)
                    self.endSceneNode.addChild(self.start_Label)
                })
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 42) {
            if let startMenuScene = SKScene(fileNamed: "EndingScene.sks") {
                startMenuScene.enumerateChildNodes(withName: "pass_Label5", using: { (node, stop) ->    Void in
                    self.start_Label = node as! SKLabelNode
                    self.start_Label.removeFromParent()
                    self.start_Label.alpha = 0.0
                    let act = SKAction.sequence([
                        SKAction.fadeIn(withDuration: 0.5),
                        SKAction.wait(forDuration: 4),
                        ])
                    self.start_Label.run(act)
                    self.endSceneNode.addChild(self.start_Label)
                })
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 48) {
            if let status = SKScene(fileNamed: "EndingScene.sks") {
                //star
                status.enumerateChildNodes(withName: "icon_star", using: { (node, stop) -> Void in
                    let icon_star = node as! SKSpriteNode
                    icon_star.removeFromParent()
                    icon_star.name = "icon_star"
                    icon_star.alpha = 0.0
                    icon_star.run(SKAction.fadeIn(withDuration: 0.5))
                    self.endSceneNode.addChild(icon_star)
                })
                //facebook
                status.enumerateChildNodes(withName: "icon_facebook", using: { (node, stop) -> Void in
                    let icon_facebook = node as! SKSpriteNode
                    icon_facebook.removeFromParent()
                    icon_facebook.name = "icon_facebook"
                    icon_facebook.alpha = 0.0
                    icon_facebook.run(SKAction.fadeIn(withDuration: 0.5))
                    self.endSceneNode.addChild(icon_facebook)
                })
                //twitter
                status.enumerateChildNodes(withName: "icon_twitter", using: { (node, stop) -> Void in
                    let icon_twitter = node as! SKSpriteNode
                    icon_twitter.removeFromParent()
                    icon_twitter.name = "icon_twitter"
                    icon_twitter.alpha = 0.0
                    icon_twitter.run(SKAction.fadeIn(withDuration: 0.5))
                    self.endSceneNode.addChild(icon_twitter)
                })
            }
            
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 53) {
            if let status = SKScene(fileNamed: "EndingScene.sks") {
                status.enumerateChildNodes(withName: "back_Label", using: { (node, stop) -> Void in
                    let back_Label = node as! SKLabelNode
                    back_Label.removeFromParent()
                    back_Label.name = "back_Label"
                    back_Label.alpha = 0.0
                    back_Label.run(SKAction.fadeIn(withDuration: 0.5))
                    self.endSceneNode.addChild(back_Label)
                })
            }
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
        self.backScrNode.physicsBody!.velocity =  CGVector(dx: 0.0, dy: -200)
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

