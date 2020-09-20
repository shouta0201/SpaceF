//
//  Stage009.swift
//

import UIKit
import SpriteKit
import AVFoundation

class Stage009: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    
    let gsCore = GameSceneController()
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: シーンが表示されたときに呼ばれる関数
    override func didMove(to view: SKView) {
        
        //ステージプロパティ///////////////////////////////////////////
        gsCore.speedvelocity = 150   //スピード設定
        gsCore.stageSuu = "9"      //ステージ数
        if appDelegate.gameMode == "normal" {
            gsCore.sksName = "Stage009_normal.sks"
        }else {
            gsCore.sksName = "Stage009.sks"
        }
        gsCore.goalPotision = -11000  //ゴールポジション　-11000
        gsCore.playerBodyCircle = 6  //プレイヤーあたり判定半径
        gsCore.scrollBool = true   //スクロールOnOff
        gsCore.scrollSpeed = 200    //スクロールスピード. ex 20000ピクセル 600秒でスロー
        gsCore.fireBool = true   //fireパーティクルOnOff
        gsCore.hCount = 24		//縦の画面数  1は667ピクセル
        gsCore.wCount = 5		//幅の画面数  1は375ピクセル
        gsCore.startPosX = 0.5   //プレイヤーポジション.0〜1  1で画面端
        gsCore.startPosY = 0.4   //プレイヤーポジション.0〜1  1で画面端
        /////////////////////////////////////////////////////////////
        gsCore.status1.stageSuu = gsCore.stageSuu
        gsCore.backgroundColor = SKColor.clear
        
        // 再生する音源のURLを生成
        if appDelegate.audiomusic != "Fstage3" {
            appDelegate.audiomusic = "Fstage3"
            appDelegate.audioSet()
            appDelegate.audioPlayer.delegate = self
            appDelegate.audioPlayer.numberOfLoops = -1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.appDelegate.audioPlayer.play()
            }
        }

        //ステージ画面生成
        gsCore.initScene()
        
        //画面add
        self.addChild(gsCore.status1.stetusNode)
        self.addChild(gsCore.baseNode)
        self.addChild(gsCore.backScrNode)
        
        //接触デリゲート
        self.physicsWorld.contactDelegate = self
        
        //パーティクル Bool  //////////
        if gsCore.fireBool == true{
            gsCore.fireparticle()
        }
        //自動スクロール Bool  //////////
        if gsCore.scrollBool == true{
            gsCore.autoScroll()
        }
        
    }
    
    //タッチダウンされたときに呼ばれる関数
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var location: CGPoint!
        for touch in touches {
            location = touch.location(in: self)
        }
        gsCore.tapPoint = location
        gsCore.player1.playerNode.physicsBody!.linearDamping = 0.0
    }
    
    //タッチ移動
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var location: CGPoint!
        for touch in touches {
            location = touch.location(in: self)
        }
        if gsCore.goalingBool == false{
            gsCore.player1.playerMoveAction(tapPoint: gsCore.tapPoint, location: location)
        }
    }
    
    //タッチエンド
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gsCore.player1.tapping = false
        var location: CGPoint!
        for touch in touches {
            location = touch.location(in: self)
        }
        let touchNode = atPoint(location)
        
        //RESTART///次の画面クラス入力必要///////////////////////////////
        if touchNode.name == "restartLabel"
        {
            //残機挿入
            gsCore.appDelegate.zankiSuu = gsCore.initZankisuu
            
            // X-1ステージに戻る
            let scene = Stage009(size: CGSize(width: frame.size.width,height: frame.size.height))
            scene.scaleMode = .aspectFill
            self.view!.presentScene(scene)
        }
        //CONTIMUE 同じステージ
        if touchNode.name == "continueRect"
        {
            let scene = Stage009(size: CGSize(width: frame.size.width,height: frame.size.height))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1.0)
            self.view!.presentScene(scene, transition:transition)
        }
        //NextStage 次のステージへ
        if touchNode.name == "nextStageRect"
        {
            //AUDIO STOP
            appDelegate.audioPlayer.stop()
            let scene = Stage00F(size: CGSize(width: frame.size.width,height: frame.size.height))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1.0)
            self.view!.presentScene(scene, transition:transition)
        }
        //EXIT
        if touchNode.name == "exitLabel"
        {
            //AUDIO STOP
            appDelegate.audioPlayer.stop()
            let scene = StartMenu(size: CGSize(width: frame.size.width,height: frame.size.height))
            scene.scaleMode = .aspectFill
            self.view!.presentScene(scene)
        }
        
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

    }
    
    //シーンのアップデート時に呼ばれる関数
    override func update(_ currentTime: TimeInterval) {
        
        //シーンのアップデート時
        if gsCore.player1.gekitotsuing == false{
            gsCore.gsupdate()
        }
        
        //ゴール時のアクション
        if gsCore.yPos < gsCore.goalPotision && gsCore.playingNow == true {
            gsCore.playingNow = false
            gsCore.goalMoveAction()
            if appDelegate.gameMode == "normal"{
                appDelegate.clearStageMemory.set(true, forKey: "stage00Fc_normal")
            }else{
                appDelegate.clearStageMemory.set(true, forKey: "stage00Fc")
            }

        }
        
        //激突したときのアクション
        if gsCore.player1.gekitotsuing == true && gsCore.playingNow == true  {
            gsCore.playingNow = false
            Timer.scheduledTimer(timeInterval: 1.0,target: self,selector: #selector(self.getNextScene),userInfo: nil,repeats: false
            )
        }
        
        //隕石を消すメソッド
        gsCore.outsideStoneAction()
        
        
        
    }
    
    //接触判定
    func didBegin(_ contact: SKPhysicsContact) {
        gsCore.gsBokan()
    }
    
    //すべてのアクションと物理シミュレーション処理後、1フレーム毎に呼び出される
    override func didSimulatePhysics() {
    }
    
    
    @objc func getNextScene(){
        //zankiが0ならオーバー
        if gsCore.appDelegate.zankiSuu == 0{
            gsCore.gameOverRect()
        }else{
            gsCore.continueRect()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
    }
    
}