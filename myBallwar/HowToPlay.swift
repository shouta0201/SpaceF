//
//  HowToPlay.swift
//  myBallwar
import Foundation

import UIKit
import SpriteKit

class HowToPlay: SKScene, SKPhysicsContactDelegate {

    let baseNode = SKNode()						//ゲームベースノード
    let backScrNode = SKNode()					//背景ノード
    var oneScreenSize = UIScreen.main.bounds.size	//１画面サイズ


    //タッチエンド
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var location: CGPoint!
        for touch in touches {
            location = touch.location(in: self)
        }
        let touchNode = atPoint(location)

        //TAP START BUTTON
        if touchNode.name == "backtitle"
        {
            let scene = StartMenu(size: CGSize(width: frame.size.width , height: frame.size.height ))
            scene.scaleMode = .aspectFill
            let transition = SKTransition.moveIn(with: SKTransitionDirection.down, duration: 1)
            self.view!.presentScene(scene, transition: transition)
        }
    }

    
    //MARK: シーンが表示されたときに呼ばれる関数
    override func didMove(to view: SKView) {

        self.backgroundColor = SKColor.clear
        self.addChild(self.baseNode)

        //シーンファイルを読み込み
        if let startMenuScene = SKScene(fileNamed: "HowToPlay.sks") {
            //HowToLabel
            startMenuScene.enumerateChildNodes(withName: "HowToLabel", using: { (node, stop) -> Void in
                let HowToLabel = node as! SKLabelNode
                HowToLabel.name = "HowToLabel"
                HowToLabel.removeFromParent()
                self.baseNode.addChild(HowToLabel)
            })
            //HowToPlayer
            startMenuScene.enumerateChildNodes(withName: "HowToPlayer", using: { (node, stop) -> Void in
                let HowToPlayer = node as! SKSpriteNode
                HowToPlayer.name = "HowToPlayer"
                HowToPlayer.removeFromParent()
                self.baseNode.addChild(HowToPlayer)
            })
            //HowToStone
            startMenuScene.enumerateChildNodes(withName: "HowToStone", using: { (node, stop) -> Void in
                let HowToStone = node as! SKSpriteNode
                HowToStone.name = "HowToStone"
                HowToStone.removeFromParent()
                self.baseNode.addChild(HowToStone)
            })
            //背景
            startMenuScene.enumerateChildNodes(withName: "back_wall", using: { (node, stop) -> Void in
                let back_wall = node as! SKSpriteNode
                back_wall.name = NodeName.backGround.rawValue
                //シーンから削除して再配置
                back_wall.removeFromParent()
                self.baseNode.addChild(back_wall)
            })
        }
        
        //空NODE
        let width = self.oneScreenSize.width
        let height = self.oneScreenSize.height
        let backtitle = SKShapeNode(rect: CGRect(x: -5, y: -5, width: width + 10, height: height + 10))
        backtitle.fillColor = UIColor.black
        backtitle.zPosition = 7
        backtitle.alpha = 0.01
        backtitle.name = "backtitle"
        
        self.baseNode.addChild(backtitle)

    }
    
    //MARK: - タッチ処理
    //タッチダウンされたときに呼ばれる関数
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    //タッチ移動
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    //MARK: - シーンのアップデート時に呼ばれる関数
    override func update(_ currentTime: TimeInterval) {
        
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

