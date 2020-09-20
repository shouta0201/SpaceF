//
//  GameSceneController.swift
//

import UIKit
import SpriteKit
import Social
import AVFoundation
import GameKit

class GameSceneController: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var myComposeView : SLComposeViewController!
    var audioPlayer:AVAudioPlayer!

    /////////////////////////////////////////
    let initZankisuu = 3        //初期残機数
    /////////////////////////////////////////
    
    let player1 = GamePlayer()
    let status1 = GameStatus()
    let baseNode = SKNode()     //ゲームベースノード
    let backScrNode = SKNode()  //背景ノード
    var scrollBool: Bool = false //スクロールBool
    var fireBool:Bool = false //FireパーティクルBool
    var scrollSpeed = 200
    var goalingBool:Bool = false

    var playerBodyCircle: CGFloat = 0
    var playingNow:Bool = true  //クリア時にはfalse
    var wCount = 0		//幅の画面数
    var hCount = 0		//縦の画面数
    var oneScreenSize = UIScreen.main.bounds.size	//１画面サイズ
    var allScreenSize = CGSize()                    //全画面サイズ
    var xPos: CGFloat = 0
    var yPos: CGFloat = 0
    var speedvelocity:Int = 0             //スピード設定
    var goalPotision: CGFloat = 0   //ゴールポジション
    var stageSuu: String = ""        //ステージ数
    var sksName: String = ""        //sks名
    var startPosX: CGFloat = 0      //画面比比率
    var startPosY: CGFloat = 0      //画面比比率
    var fireHeight: CGFloat = 30    // 炎の高さ

    var stone: SKSpriteNode!
    var noise: SKFieldNode!
    var moveStone: SKSpriteNode!
    var blackspuare: SKShapeNode!
    var sunfireNode: SKSpriteNode!
    var tapPoint: CGPoint = CGPoint.zero
    var tapEndPoint: CGPoint = CGPoint.zero
    var particle = SKEmitterNode()
    var particleNode: SKShapeNode = SKShapeNode()
    var particleRect: SKShapeNode = SKShapeNode()
    
    
    //太陽の炎
    func fireparticle(){
        let path = Bundle.main.path(forResource: "myfire", ofType: "sks")
        self.particle = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
        self.particle.position.x = self.allScreenSize.width / 2
        self.particle.position.y = self.baseNode.position.y + appDelegate.admobheight/2
        self.particle.zPosition = 7
        self.baseNode.addChild(self.particle)

        //激突用のノード
        self.particleNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.allScreenSize.width , height: 50))
        self.particleNode.physicsBody!.isDynamic = false
        self.particleNode.position.x = self.allScreenSize.width / 2
        self.particleNode.position.y = self.baseNode.position.y + appDelegate.admobheight/2
        self.particleNode.physicsBody!.categoryBitMask = NodeName.sunfire.category()
        self.particleNode.zPosition = 7
        self.baseNode.addChild(self.particleNode)
    }
    
    //自動スクロール
    func autoScroll(){
                baseNode.run(SKAction.moveTo(y: -20000, duration: TimeInterval(scrollSpeed)), withKey: "baseNodeScroll")
        backScrNode.run(SKAction.moveTo(y: -20000/4, duration: TimeInterval(scrollSpeed)), withKey: "backScrNodeScroll")
        if fireBool == true{
            particle.run(SKAction.moveTo(y: 20000, duration: TimeInterval(scrollSpeed)), withKey: "particleScroll")
            particleNode.run(SKAction.moveTo(y: 20000, duration: TimeInterval(scrollSpeed)), withKey: "particleNodeScroll")
        }
    }
    
    func stopScroll(){
        baseNode.removeAllActions()
        backScrNode.removeAllActions()
        particle.removeAllActions()
        particleNode.removeAllActions()
    }
    
    func initScene(){
        oneScreenSize = CGSize(width: UIScreen.main.bounds.size.width * appDelegate.scaleSize ,height: (UIScreen.main.bounds.size.height * appDelegate.scaleSize) ) //１画面サイズ

        //剛体化
        baseNode.physicsBody = SKPhysicsBody()
        baseNode.physicsBody!.affectedByGravity = false
        backScrNode.physicsBody = SKPhysicsBody()
        backScrNode.physicsBody!.affectedByGravity = false
        particle.physicsBody = SKPhysicsBody()
        particle.physicsBody!.affectedByGravity = false

        //全画面サイズ
        allScreenSize = CGSize(width: self.oneScreenSize.width * CGFloat(wCount) , height: self.oneScreenSize.height * CGFloat(hCount))
        
        //シーンファイルを読み込み
        if let scene1 = SKScene(fileNamed: self.sksName) {

            //背景
            scene1.enumerateChildNodes(withName: "back_wall", using: { (node, stop) -> Void in
                let back_wall = node as! SKSpriteNode
                back_wall.name = NodeName.backGround.rawValue
                back_wall.removeFromParent()
                self.backScrNode.addChild(back_wall)
            })
            //MARK: プレイヤー
            self.player1.charXOffset = self.oneScreenSize.width * startPosX
            self.player1.charYOffset = self.oneScreenSize.height * startPosY
            scene1.enumerateChildNodes(withName: "player", using: { (node, stop) -> Void in
                let player = node as! SKSpriteNode
                self.player1.playerNode = player
                player.removeFromParent()
                //物理設定
                self.baseNode.addChild(self.player1.playerNode)
                self.player1.playerNode.physicsBody = SKPhysicsBody(circleOfRadius: self.playerBodyCircle)

        //        self.player1.playerNode.position.x =  self.player1.charXOffset
        //        self.player1.playerNode.position.y =  self.player1.charYOffset

                self.player1.playerNode.physicsBody!.affectedByGravity = false
                self.player1.playerNode.physicsBody!.friction = 0		//摩擦 linearDamping
                self.player1.playerNode.physicsBody!.linearDamping = 0		//
                self.player1.playerNode.physicsBody!.allowsRotation = false	//回転禁止
                self.player1.playerNode.physicsBody!.restitution = 0.0		//跳ね返り値
                self.player1.playerNode.physicsBody!.categoryBitMask = NodeName.player.category()
                self.player1.playerNode.physicsBody!.collisionBitMask = NodeName.frame_ground.category()|NodeName.stone.category()|NodeName.moveStone.category()|NodeName.sunfire.category()|NodeName.frame_ground.category()
                self.player1.playerNode.physicsBody!.contactTestBitMask = NodeName.frame_ground.category()|NodeName.stone.category()|NodeName.moveStone.category()|NodeName.sunfire.category()|NodeName.frame_ground.category()
                self.player1.playerNode.physicsBody!.usesPreciseCollisionDetection = true
            })
            //画面外周
            let wallFrameNode = SKNode()
            self.baseNode.addChild(wallFrameNode)
            //読み込んだシーンのサイズから外周
            wallFrameNode.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: appDelegate.admobheight/2 , width: allScreenSize.width, height: allScreenSize.height - appDelegate.admobheight/2))
            wallFrameNode.physicsBody!.categoryBitMask = NodeName.frame_ground.category()
            wallFrameNode.physicsBody!.usesPreciseCollisionDetection = true
            //固定石
            scene1.enumerateChildNodes(withName: "stone", using: { (node, stop) -> Void in
                let stone = node as! SKSpriteNode
                stone.name = NodeName.stone.rawValue
                self.stone = stone
                stone.removeFromParent()
                self.baseNode.addChild(stone)
                self.stone.physicsBody!.categoryBitMask = NodeName.stone.category()
                
            })
            //移動石
            for i in (0 ..< 100) {
                let withName = "moveStone" + String(i)
                scene1.enumerateChildNodes(withName: withName , using: { (node, stop) -> Void in
                    let moveStone = node as! SKSpriteNode
                    moveStone.name = NodeName.moveStone.rawValue
                    self.moveStone = moveStone
                    moveStone.removeFromParent()
                    self.baseNode.addChild(moveStone)
                    self.moveStone.physicsBody!.categoryBitMask = NodeName.moveStone.category()

                })
            }
            

            //初期速度
            self.player1.speedvelocity = CGFloat(speedvelocity)
            self.player1.playerNode.physicsBody!.velocity = CGVector(dx: 0.0, dy: player1.speedvelocity)
            
        }


        
        //ステータス画面生成
        status1.statusEditCall()


        //空NODE
        let width = self.oneScreenSize.width * 6
        let height = self.oneScreenSize.height * 6
        let openingRect = SKShapeNode(rect: CGRect(x: -(self.oneScreenSize.width * 3), y: -5, width: width + 10, height: height + 10))
        openingRect.fillColor = UIColor.black
        openingRect.zPosition = 10
        self.status1.stetusNode.addChild(openingRect)

        //フェードイン
        let openingAction = SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.fadeOut(withDuration: 0.5)
            ])
        openingRect.run(openingAction)
 
        
    }

    func goalMoveAction(){

        //剛体解除
        self.player1.playerNode.physicsBody?.isDynamic = false
        self.player1.moveStop()
        self.goalingBool = true
        self.player1.playerNode.texture = SKTexture(imageNamed: "player_up")

        //スクロールがONならストップスクロールを実行
//        if scrollBool == true{
//            stopScroll()
//        }
  
        //画面自動スクロール
        let moveToAction = SKAction.moveTo(y: baseNode.position.y - 300, duration: 21.0)
        self.baseNode.run(moveToAction)
        let moveToAction1 = SKAction.moveTo(y: backScrNode.position.y - 300, duration: 21.0)
        self.backScrNode.run(moveToAction1)
        let moveToAction2 = SKAction.moveTo(y: particle.position.y - 300, duration: 21.0)
        self.particle.run(moveToAction2)
        self.particleNode.run(moveToAction2)
        
        
        //Player move
        let goalAction = SKAction.sequence([
//            SKAction.move(to: CGPoint(x: allScreenSize.width/2,y: -(yPos) + oneScreenSize.height/2 + 100), duration: 1.5),
            SKAction.move(to: CGPoint(x: -(xPos) + oneScreenSize.width/2 , y: -(yPos) + oneScreenSize.height/2 + 100), duration: 1.5),
            SKAction.wait(forDuration: 2),
            SKAction.moveTo(y: player1.playerNode.position.y + 3000, duration: 3),
            SKAction.removeFromParent()
            ])
        self.player1.playerNode.run(goalAction)
        
        
        Timer.scheduledTimer(timeInterval: 3.0,target: self,selector: #selector(self.goNextView),userInfo: nil,repeats: false
        )
    }
    
    @objc func goNextView(){
        //Go Next 表示
        let goNextLabel: SKLabelNode = SKLabelNode()
        goNextLabel.fontSize = 40
        goNextLabel.fontColor = UIColor.white
        
        if self.status1.stageSuu == "F" {
            goNextLabel.text = ""
        }else{
            goNextLabel.text = "GO NEXT !"
        }
        goNextLabel.position = CGPoint(x:oneScreenSize.width/2 , y:oneScreenSize.height/2)
        goNextLabel.zPosition = 7
        self.status1.stetusNode.addChild(goNextLabel)
        
        //空NODE
        let width = self.oneScreenSize.width
        let height = self.oneScreenSize.height
        let nextStageRect = SKShapeNode(rect: CGRect(x: -5, y: -5, width: width + 10, height: height + 10))
        
        nextStageRect.fillColor = UIColor.black
        nextStageRect.zPosition = 7
        nextStageRect.alpha = 0.01
        nextStageRect.name = "nextStageRect"
        
        self.status1.stetusNode.addChild(nextStageRect)
        
    }
    
    func gsBokan(){

        if self.player1.gekitotsuing == false && !appDelegate.debugFlag {
            //2重激突防止 On
            player1.gekitotsuing = true
        
            stopScroll()
            player1.playerDirection = .neutral
            player1.moveStop()
            player1.playerNode.physicsBody!.isDynamic = false

            //デバッグならこれをコメントアウト
            player1.playerNode.removeFromParent()
        
            //爆発音
            //self.run(SKAction.playSoundFileNamed("boomer.mp3", waitForCompletion: true))
            let soundFilePath : String = Bundle.main.path(forResource: "boomer", ofType: "mp3")!
            let fileURL : URL = URL(fileURLWithPath: soundFilePath)
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                audioPlayer.delegate = self
            }
            catch{
            }
            audioPlayer.play()

            
            //パーティクル生成
            particleView()
            self.appDelegate.zankiSuu = self.appDelegate.zankiSuu - 1
            self.baseNode.addChild(self.particle)

            //フラッシュ＋画面揺らす
            gatagataFlashAction()
            
        } else {
            particleView()
            self.baseNode.addChild(self.particle)
        }
        
    }
        
    
    func continueRect(){
        //空NODE
        let width = self.oneScreenSize.width
        let height = self.oneScreenSize.height
        let continueRect = SKShapeNode(rect: CGRect(x: -5, y: -5, width: width + 10, height: height + 10))
        
        continueRect.fillColor = UIColor.clear
        continueRect.name = "continueRect"
        continueRect.zPosition = 6
        continueRect.alpha = 0.01
        
        self.status1.stetusNode.addChild(continueRect)
    }

    //Game Over
    func gameOverRect(){
        
        Timer.scheduledTimer(timeInterval: 2.0,target: self,selector: #selector(self.gameOverInterstitial),userInfo: nil,repeats: false
        )
    }

    
    //Game Over
    @objc func gameOverInterstitial(){
        //Interstitial
        appDelegate.viewController.alertView()
        appDelegate.viewController.interstitialDidDismissScreen()

        //フェードイン
        self.baseNode.run(SKAction.wait(forDuration: 1))
        
        //RESTART 表示
        let restartLabel: SKLabelNode = SKLabelNode()
        restartLabel.fontSize = 30
        restartLabel.fontColor = UIColor.white
        restartLabel.name = "restartLabel"
        restartLabel.text = "RESTART"
        restartLabel.position = CGPoint(x:oneScreenSize.width/2 , y:oneScreenSize.height/2 )
        restartLabel.zPosition = 7
        restartLabel.alpha = 0.0
        restartLabel.run(SKAction.fadeIn(withDuration: 0.5))
        self.status1.stetusNode.addChild(restartLabel)
        //RESTART 表示
        let exitLabel: SKLabelNode = SKLabelNode()
        exitLabel.fontSize = 30
        exitLabel.fontColor = UIColor.white
        exitLabel.name = "exitLabel"
        exitLabel.text = "EXIT"
        exitLabel.position = CGPoint(x:oneScreenSize.width/2 , y:oneScreenSize.height/2 - 100)
        exitLabel.zPosition = 7
        exitLabel.alpha = 0.0
        exitLabel.run(SKAction.fadeIn(withDuration: 0.5))
        self.status1.stetusNode.addChild(exitLabel)
        //空NODE
        let width = self.oneScreenSize.width
        let height = self.oneScreenSize.height
        let gameoverRect = SKShapeNode(rect: CGRect(x: -5, y: -5, width: width + 10, height: height + 10))
        gameoverRect.fillColor = UIColor.black
        gameoverRect.zPosition = 6
        gameoverRect.alpha = 0.8
        
        if let status = SKScene(fileNamed: "GameStatus.sks") {
            //star
            status.enumerateChildNodes(withName: "icon_star", using: { (node, stop) -> Void in
                let icon_star = node as! SKSpriteNode
                icon_star.removeFromParent()
                icon_star.name = "icon_star"
                icon_star.alpha = 0.0
                icon_star.run(SKAction.fadeIn(withDuration: 0.5))
                self.status1.stetusNode.addChild(icon_star)
            })
            //facebook
            status.enumerateChildNodes(withName: "icon_facebook", using: { (node, stop) -> Void in
                let icon_facebook = node as! SKSpriteNode
                icon_facebook.removeFromParent()
                icon_facebook.name = "icon_facebook"
                icon_facebook.alpha = 0.0
                icon_facebook.run(SKAction.fadeIn(withDuration: 0.5))
                self.status1.stetusNode.addChild(icon_facebook)
            })
            //twitter
            status.enumerateChildNodes(withName: "icon_twitter", using: { (node, stop) -> Void in
                let icon_twitter = node as! SKSpriteNode
                icon_twitter.removeFromParent()
                icon_twitter.name = "icon_twitter"
                icon_twitter.alpha = 0.0
                icon_twitter.run(SKAction.fadeIn(withDuration: 0.5))
                self.status1.stetusNode.addChild(icon_twitter)
            })
        }
        
        self.status1.stetusNode.addChild(gameoverRect)

    }
    
    
    func postToFacebook(){
        
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        // 投稿するテキストを指定.
        myComposeView.setInitialText("Space F")
        // 投稿する画像を指定.
        myComposeView.add(UIImage(named: "icon_main120.png"))

        // myComposeViewの画面遷移.
        let currentViewController : UIViewController? = UIApplication.shared.keyWindow?.rootViewController!
        
        currentViewController!.present(myComposeView, animated: true, completion: nil)

    }

    func postToTwitter(){
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        // 投稿するテキストを指定.
        myComposeView.setInitialText("Space F")
        // 投稿する画像を指定.
        myComposeView.add(UIImage(named: "icon_main120.png"))
        
        // myComposeViewの画面遷移.
        let currentViewController : UIViewController? = UIApplication.shared.keyWindow?.rootViewController!
        
        currentViewController!.present(myComposeView, animated: true, completion: nil)
    }

    func postToReview(){
        let itunesURL:String = "https://itunes.apple.com/jp/app/space-f/id1196202079?mt=8"
        let url = URL(string:itunesURL)
        let app:UIApplication = UIApplication.shared
        if #available(iOS 10.0, *) {
            app.open(url!)
        } else {
            app.openURL(url!)
        }

        
        
    }

    
    func particleView(){
        let path = Bundle.main.path(forResource: "myspark", ofType: "sks")
        let particle = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
        self.particle = particle
        particle.position = self.player1.playerNode.position
        particle.zPosition = 5
        
        // particleのもろもろの設定
        particle.numParticlesToEmit = 10 // 何個、粒を出すか。
        particle.particleBirthRate = 5 // 一秒間に何個、粒を出すか。
        particle.particleSpeed = 5 // 粒の速度
        particle.xAcceleration = 0
        particle.yAcceleration = 0 // 加速度を0にすることで、重力がないようになる。

    }
    
    func calcCompRate(){
        var compRate = 0

        if appDelegate.clearStageMemory.bool(forKey: "stage002c"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage003c"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage004c"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage005c"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage006c"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage007c"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage008c"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage009c"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage00Fc"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stageFFFc"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage002c_normal"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage003c_normal"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage004c_normal"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage005c_normal"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage006c_normal"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage007c_normal"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage008c_normal"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage009c_normal"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stage00Fc_normal"){ compRate = compRate + 5 }
        if appDelegate.clearStageMemory.bool(forKey: "stageFFFc_normal"){ compRate = compRate + 5 }

        appDelegate.compRate = String(compRate)
        
    }
    
    
    func gsupdate(){
        
        //シーン上でのプレイヤーの座標をbaseNodeからの位置に変換
        
        if scrollBool == false{
            let PlayerPt = self.convert(player1.playerNode.position, from: baseNode)
            //シーン上でプレイヤー位置を基準にしてbaseNodeの位置を変更する
            xPos = baseNode.position.x - PlayerPt.x + player1.charXOffset
            yPos = baseNode.position.y - PlayerPt.y + player1.charYOffset
            //スクロール制限
            if xPos <= -(self.allScreenSize.width - self.oneScreenSize.width) {
                xPos = -(self.allScreenSize.width - self.oneScreenSize.width)
            }
            if xPos > 0 {
                xPos = 0
            }
            if yPos <= -(self.allScreenSize.height - self.oneScreenSize.height) {
                yPos = -(self.allScreenSize.height - self.oneScreenSize.height)
            }
            if yPos > 0 {
                yPos = 0
            }
        }else{
            let PlayerPt = self.convert(player1.playerNode.position, from: baseNode)
            //シーン上でプレイヤー位置を基準にしてbaseNodeの位置を変更する
            xPos = baseNode.position.x - PlayerPt.x + player1.charXOffset
            //スクロール制限
            if xPos <= -(self.allScreenSize.width - self.oneScreenSize.width) {
                xPos = -(self.allScreenSize.width - self.oneScreenSize.width)
            }
            if xPos > 0 {
                xPos = 0
            }

            yPos = baseNode.position.y
            
        }


        self.baseNode.position = CGPoint(x: xPos, y: yPos)
        
        //背景の無限ループ
        self.backScrNode.position = CGPoint(x: xPos/4, y: yPos/4)
        self.backScrNode.position.x = self.backScrNode.position.x.truncatingRemainder(dividingBy: 500)
        self.backScrNode.position.y = self.backScrNode.position.y.truncatingRemainder(dividingBy: 800)
        
        //speedvelocityを挿入
        self.status1.speed_meter.text = String(describing: Int(self.player1.speedvelocity))

        
    }
    
    override func didMove(to view: SKView) {
    }
    
    
    func outsideStoneAction(){
        
        self.baseNode.enumerateChildNodes(withName: "moveStone" , using: { (node, stop) -> Void in
            let moveStone = node as! SKSpriteNode
            if moveStone.position.y < 0 - moveStone.size.height - moveStone.size.width {
                
                //幅と高さの長さ分だけ隠れたら、スクリーンサイズより上から再度出現する
                moveStone.position.y = self.allScreenSize.height + moveStone.size.height + moveStone.size.width
            }
        })
        
    }
    
    func gatagataFlashAction(){
    
        //空NODE
        let width = self.oneScreenSize.width * 6
        let height = self.oneScreenSize.height * 6
        let flashRect = SKShapeNode(rect: CGRect(x: -(self.oneScreenSize.width * 3), y: -5, width: width + 10, height: height + 10))
        flashRect.fillColor = UIColor.white
        flashRect.alpha = 0.5
        flashRect.zPosition = 10
        self.status1.stetusNode.addChild(flashRect)
        
        //フェードイン
        let openingAction = SKAction.sequence([
            SKAction.fadeOut(withDuration: 1)
            ])
        flashRect.run(openingAction)

        
        //画面揺らす
        let gatagataAction = SKAction.sequence([
            SKAction.moveBy(x : 3, y : 3, duration: 0.01),
            SKAction.moveBy(x : -3, y : -3, duration: 0.01),
            SKAction.moveBy(x : -3, y : -3, duration: 0.01),
            SKAction.moveBy(x : 3, y : 3, duration: 0.01),
            
            SKAction.moveBy(x : -3, y : 3, duration: 0.02),
            SKAction.moveBy(x : 3, y : -3, duration: 0.02),
            SKAction.moveBy(x : 3, y : -3, duration: 0.02),
            SKAction.moveBy(x : -3, y : 3, duration: 0.02),
            
            SKAction.moveBy(x : 5, y : 5, duration: 0.03),
            SKAction.moveBy(x : -5, y : -5, duration: 0.03),
            SKAction.moveBy(x : -5, y : -5, duration: 0.03),
            SKAction.moveBy(x : 5, y : 5, duration: 0.03),
            
            ])
        
        self.baseNode.run(gatagataAction)
        self.backScrNode.run(gatagataAction)

    }
    


}

    /*
    func createAndLoadInterstitial2() {
        appDelegate.viewController.interstitial = GADInterstitial(adUnitID: "ca-app-pub-3863821336817317/9937155583")
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        appDelegate.viewController.interstitial.load(GADRequest())
    }
*/


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


enum NodeName: String {
    
    case sunfire = "sunfire"	//SPEED
    case gravity = "gravity"	//gravity
    case touch_meter = "touch_meter"	//SPEED
    case speed_meter = "speed_meter"	//SPEED
    case speed_meter_label = "speed_meter_label"	//SPEED LABEL
    case frame_ground = "frame_ground"	//地面あたり
    case frame_floor = "frame_floor"	//浮床あたり
    case player = "player"				//プレイヤー
    case backGround = "backGround"		//背景
    case ground = "ground"				//地面
    case stone = "stone"				//固定隕石
    case moveStone = "moveStone"		//動く隕石
    
    //接触カテゴリビットマスク
    func category()->UInt32{
        switch self {
        case .frame_ground:	//画面端あたり
            return 0x00000001 << 0
        case .frame_floor:	//浮床あたり
            return 0x00000001 << 1
        case .stone:		//固定隕石
            return 0x00000001 << 2
        case .moveStone:	//移動隕石
            return 0x00000001 << 3
        case .sunfire:         //炎
            return 0x00000001 << 4
        case .player:		//プレイヤー
            return 0x00000001 << 5
        default:
            return 0x00000000
        }
    }
}
