//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

var towers: [[Int]] = [[3, 2, 1], [], []]
let winState: [[Int]] = [[], [], [3, 2, 1]]
var picked: Int = 0

class Tower: UIButton {
    static var numButtons = 0
    static var moves = 0
    var numDisc = 0
    
    func setup() {
        numDisc = Tower.numButtons
        Tower.numButtons += 1
    }
    
    override func draw(_ rect: CGRect) {
        guard let cg = UIGraphicsGetCurrentContext() else {return}
        
        cg.setFillColor(UIColor.black.cgColor)
        cg.fill(bounds)
        
        func drawOval(_ size: Int, _ location: Int) {
            let oWidth = 100
            let oShrink = 40
            let centerX = 150
            let bottomY = 245 - oWidth
            
            let w = oWidth + size * oShrink
            let h = 50
            let x = centerX - w/2
            let y = bottomY - h * location * 7/10 - location * 10

            for i in 0 ... 20 {
                let rect = CGRect(x: x, y: y-i, width: w, height: h - i)
                let path = UIBezierPath(ovalIn: rect)
                UIColor.black.setStroke()
                path.stroke()
                UIColor.white.setFill()
                path.fill()
            }

        }

        for i in 0 ..< towers[numDisc].count {
            drawOval(towers[numDisc][i], i)
        }
        
    }
    
}
class MyViewController : UIViewController {
    var tower0 = Tower()
    var tower1 = Tower()
    var tower2 = Tower()
    
    override func loadView() {
        
        print("Objective: Move the entire stack of discs from the first button to the third one.\n\nRules:\n1) Only one disc can be moved at a time. \n2) No disk can be placed on top of the smaller disk.\n")
        
        let view = UIView()
        view.backgroundColor = .white
        
        tower0.setup()
        tower1.setup()
        tower2.setup()
                    
        tower0.frame = CGRect(x: 40, y: 15, width: 300, height: 200)
        tower1.frame = CGRect(x: 40, y: 230, width: 300, height: 200)
        tower2.frame = CGRect(x: 40, y: 445, width: 300, height: 200)
        
        view.addSubview(tower0)
        view.addSubview(tower1)
        view.addSubview(tower2)
        
        tower0.addTarget(self, action: #selector(pushTower0), for: .touchUpInside)
        tower1.addTarget(self, action: #selector(pushTower1), for: .touchUpInside)
        tower2.addTarget(self, action: #selector(pushTower2), for: .touchUpInside)
        
        self.view = view
    }
    
    func pickUp (_ which : Int) {
        if let disc = towers[which].popLast() {
            picked = disc
        }
    }
    
    func dropDown (_ which: Int) {
        if let disc = towers[which].last {
            guard disc > picked else {
                print("You are unable to put a bigger disc on top of a smaller one. Try again.")
                return
            }
        }
        towers[which].append(picked)
        picked = 0
    }
    
    func checkWin(_ moves: Int) {
        guard towers == winState else {return}
        print("You won in \(moves) moves!")
    }
    
    func update() {
        tower0.setNeedsDisplay()
        tower1.setNeedsDisplay()
        tower2.setNeedsDisplay()
    }
    
    func pushed(_ disc: Int) {
        if picked == 0 {
            pickUp(disc)
        } else {
            dropDown(disc)
            Tower.moves += 1
        }
        update()
        checkWin(Tower.moves)
    }
    
    @objc func pushTower0() {
        pushed(0)
    }
    
    @objc func pushTower1() {
        pushed(1)
    }
    
    @objc func pushTower2() {
        pushed(2)
    }
    
}
PlaygroundPage.current.liveView = MyViewController()
