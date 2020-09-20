//
//  GamePlayer.swift
//

import UIKit
import SpriteKit

class GamePlayer: SKScene, SKPhysicsContactDelegate {

    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

    // プレイヤーキャラ
    var playerNode = SKSpriteNode()
    var playerDirection: Direction = .up        //移動方向
    var physicsRadius: CGFloat = 7.0			//物理半径
    var charXOffset: CGFloat = 0				//X位置のオフセット
    var charYOffset: CGFloat = 0				//Y位置のオフセット
    var tapping: Bool = false					//移動中フラグ
    var gekitotsuing: Bool = false

    var particle = SKEmitterNode()

    //速度
    var dx: CGFloat = 0
    var dy: CGFloat = 0
    var speedvelocity: CGFloat = 100
    var scrollvelocity: CGFloat = 10
    let distanceMinimum: CGFloat = 2.0
    
    //MARK: - 移動
    func moveToRight() {
        self.playerDirection = .right
        self.playerNode.texture = SKTexture(imageNamed: "player_right")
    }
    func moveToLeft() {
        self.playerDirection = .left
        self.playerNode.texture = SKTexture(imageNamed: "player_left")
    }
    func moveToUp() {
        self.playerDirection = .up
        self.playerNode.texture = SKTexture(imageNamed: "player_up")
    }
    func moveToDown() {
        self.playerDirection = .down
        self.playerNode.texture = SKTexture(imageNamed: "player_down")
        
        //        speedvelocity = speedvelocity + 50
    }
    func moveStop() {
        self.playerNode.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
    }

    func playerMoveAction(tapPoint: CGPoint, location: CGPoint) -> Void{
        
        let	distanceX = (location.x-tapPoint.x) * (location.x-tapPoint.x)
        let	distanceY = (location.y-tapPoint.y) * (location.y-tapPoint.y)
        
        if distanceX > distanceMinimum || distanceY > distanceMinimum
        {
            //移動角度
            let	radian = (atan2(location.y-tapPoint.y, location.x-tapPoint.x))
            let angle = radian * 180 / CGFloat(M_PI)
            
            if tapping == false{
                
                //デバッグ　ラジアンの値
                if angle > -45 && angle < 45 {
                    self.moveToRight()	//右
                }
                else if angle > 45 && angle < 135 {
                    self.moveToUp()	//上
                }
                else if angle > 135 || angle < -135 {
                    self.moveToLeft()	//左
                }
                else if angle > -135 && angle < -45 {
                    self.moveToDown()	//下
                }
                
                //速度方向
                if self.playerDirection == .right {
                    self.playerNode.physicsBody!.velocity = CGVector(dx: speedvelocity, dy: 0.0)
                }
                else if self.playerDirection == .left {
                    self.playerNode.physicsBody!.velocity = CGVector(dx: -speedvelocity, dy: 0.0)
                }
                else if self.playerDirection == .up {
                    self.playerNode.physicsBody!.velocity = CGVector(dx: 0.0, dy: speedvelocity)
                }
                else if self.playerDirection == .down {
                    self.playerNode.physicsBody!.velocity = CGVector(dx: 0.0, dy: -speedvelocity)
                }
                else if self.playerDirection == .neutral {
                    self.playerNode.physicsBody!.velocity = CGVector(dx: 0.0, dy: 0.0)
                }
                
                //繰り返し防止
                tapping = true
                    }
    }
    
    func gekitotsu(){

        //2重激突防止
        self.gekitotsuing = true
        self.playerDirection = .neutral
        self.moveStop()
        self.playerNode.physicsBody!.isDynamic = false
        self.playerNode.removeFromParent()
        self.appDelegate.zankiSuu = self.appDelegate.zankiSuu - 1
    }
}

//移動方向
enum Direction: Int {
    case neutral    = 99	//ストップ
    case right		= 0		//右
    case left		= 1		//左
    case up         = 2		//上
    case down		= 3		//下
}


}
