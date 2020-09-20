//
//  GameStatus.swift
//

import UIKit
import SpriteKit

class GameStatus: SKScene, SKPhysicsContactDelegate {
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

    var gekitotu: Int = 0
    var stageSuu: String = ""
    let stetusNode = SKNode()					//ゲームベースノード

    var fileName = ""

    //スピードラベル
    var speed_meter = SKLabelNode()
    //touch Label debbad
    var touch_meter = SKLabelNode()

    
    func setFileName(){
        
        let fWidth = UIScreen.main.bounds.size.width
        let fHeight = UIScreen.main.bounds.size.height
        if fWidth == 375 && fHeight == 667{
            self.fileName = "GameStatus.sks"
        }else if fWidth == 320 && fHeight == 568{
            self.fileName = "GameStatus.sks"
        }else if fWidth == 414 && fHeight == 736 {
            self.fileName = "GameStatus6PLUS.sks"
        }else if fWidth == 414 && fHeight == 896 {
            //            self.fileName = "GameStatusXR.sks"
            self.fileName = "GameStatusX.sks"
        }else if fWidth == 375 && fHeight == 812{
            self.fileName = "GameStatusX.sks"
        }else{
            self.fileName = "GameStatus.sks"
        }
        
        print("fWidth:\(fWidth)")
        print("fHeight:\(fHeight)")
        print("self.fileName:\(self.fileName)")
    }

    func statusEditCall(){
        
        self.setFileName()

        if let status = SKScene(fileNamed: self.fileName) {
            //speed_meter_label
            status.enumerateChildNodes(withName: "speed_meter_label", using: { (node, stop) -> Void in
                let speed_meter_label = node as! SKLabelNode
                speed_meter_label.name = "speed_meter_label"
                speed_meter_label.removeFromParent()
                self.stetusNode.addChild(speed_meter_label)
            })
            //speed_meter
            status.enumerateChildNodes(withName: "speed_meter", using: { (node, stop) -> Void in
                self.speed_meter = node as! SKLabelNode
                self.speed_meter.removeFromParent()
                self.stetusNode.addChild(self.speed_meter)
            })
            //ZankiIcon
            status.enumerateChildNodes(withName: "ZankiIcon", using: { (node, stop) -> Void in
                let ZankiIcon = node as! SKSpriteNode
                ZankiIcon.name = "ZankiIcon"
                ZankiIcon.removeFromParent()
                self.stetusNode.addChild(ZankiIcon)
            })
            //zankiSuu
            status.enumerateChildNodes(withName: "zankiSuu", using: { (node, stop) -> Void in
                let zankiSuu = node as! SKLabelNode
                zankiSuu.name = "zankiSuu"
                zankiSuu.text = String(self.appDelegate.zankiSuu)
                zankiSuu.removeFromParent()
                self.stetusNode.addChild(zankiSuu)
            })
            //stageSuu
            status.enumerateChildNodes(withName: "stageSuu", using: { (node, stop) -> Void in
                let stageSuu = node as! SKLabelNode
                stageSuu.name = "stageSuu"
                stageSuu.text = self.stageSuu
                stageSuu.removeFromParent()
                self.stetusNode.addChild(stageSuu)
            })
            //DEBBUD
            status.enumerateChildNodes(withName: "touch_meter", using: { (node, stop) -> Void in
                self.touch_meter = node as! SKLabelNode
                //シーンから削除して再配置
                self.touch_meter.removeFromParent()
                self.stetusNode.addChild(self.touch_meter)
            })
        }
    }
    
    
}
