//
//  ChocoChipViewController.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2022/03/13.
//

import UIKit
import AVFAudio

class ChocoChipViewController: UIViewController {
    
    lazy var topLine:CGFloat = view.frame.height - 400
    var cookie:CookieView!
    var cookiePercent:Double = 0.0
    var player: AVAudioPlayer?
    
    private lazy var label:UILabel = {
        let label = UILabel()
        label.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 100))
        label.center = CGPoint(x:view.center.x, y: view.frame.height-250)
        label.textAlignment = .center
        label.text = "Fomagran"
        label.font = UIFont(name: "nutella-Bold", size: 60)
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Fomagran")
        attributedString.setColor(color: .systemRed, forText: "omagran")
        label.attributedText = attributedString
        label.backgroundColor = .white
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var breadImage:UIImageView =  {
        let imageView = UIImageView(frame: CGRect(x:view.center.x - view.frame.width/2, y: view.frame.height - 230, width:view.frame.width , height: 150))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "bread.jpeg")
        return imageView
    }()
    
    private lazy var nutella:NutellaView = {
        let w = view.frame.width-97
        let nutella = NutellaView(frame:CGRect(x:view.center.x-w/2, y:view.frame.height-560, width:w, height: 200))
        nutella.layer.masksToBounds = true
        return nutella
    }()

    private lazy var chocoView:UIView = {
        let v:UIView = UIView(frame:CGRect(x:0, y: view.frame.height-400, width: view.frame.width, height: 400))
        v.backgroundColor = UIColor(red: 81/255.0, green: 45/255.0, blue: 27/255.0, alpha: 1.0)
        return v
    }()
    
    override func viewDidLoad() {
        setCookieView()
        view.addSubview(chocoView)
        view.addSubview(nutella)
        setNutellaEdge()
        view.addSubview(label)
        view.addSubview(breadImage)
        view.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 240/255, alpha: 1)
    }
    
    func setMusicPlayer(name:String,ex:String) {
        let url = Bundle.main.url(forResource:name, withExtension:ex)!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func setCookieView() {
        cookie = CookieView(frame: CGRect(x: view.center.x-50, y: view.center.y-200, width: 100, height: 100))
        cookie.layer.cornerRadius = cookie.frame.height/2
        cookie.layer.borderColor = UIColor.black.cgColor
        cookie.layer.borderWidth = 1
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(cookieDidMove(_:)))
        cookie.addGestureRecognizer(panGesture)
        view.addSubview(cookie)
    }
    
    @objc func cookieDidMove(_ gesture:UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        if gesture.state == .cancelled || gesture.state == .ended || gesture.state == .failed {
            if nutella.didTouch {
            doElasticAnimation()
            }
        }else {
            cookie.center = gesture.location(in: view)
            if cookie.center.y+cookie.frame.height/2 > topLine {
                var gap = cookie.center.y+cookie.frame.height/2 - topLine
                if gap > cookie.frame.height {
                    gap = cookie.frame.height
                }
                let percent = gap/cookie.frame.height
                cookiePercent = max(cookiePercent,percent)
                cookie.updateBezierPath(angle:Int(181 - (cookiePercent * 180)))
                if !nutella.didTouch {
                    setMusicPlayer(name: "gooey2", ex:"mp3")
                    nutella.startPoint = location
                    nutella.didTouch = true
                }
            }
            if nutella.didTouch {
                nutella.touchNutella("Changed",location)
            }
            if location.y < 342 {
                if nutella.didTouch {
                    setMusicPlayer(name: "gooey1", ex:"mp3")
                    doElasticAnimation()
                }
            }
        }
    }
    
    func doElasticAnimation() {
        nutella.touchNutella("Ended",CGPoint(x:0,y:0))
        nutella.didTouch = false
    }
    
    func setNutellaEdge() {
        let leftBottomShape:CAShapeLayer = CAShapeLayer()
        let leftBottomPath = UIBezierPath()
        leftBottomPath.move(to: CGPoint(x: 0, y: view.frame.height-100))
        leftBottomPath.addCurve(to: CGPoint(x: 50, y: view.frame.height), controlPoint1: CGPoint(x:5, y: view.frame.height-50), controlPoint2: CGPoint(x:60, y: view.frame.height))
        leftBottomPath.addLine(to: CGPoint(x:0, y: view.frame.height+25))
        leftBottomShape.strokeColor = UIColor.clear.cgColor
        leftBottomShape.fillColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 240/255, alpha: 1).cgColor
        leftBottomPath.close()
        leftBottomShape.path = leftBottomPath.cgPath
        view.layer.addSublayer(leftBottomShape)
        
        let rightBottomShape:CAShapeLayer = CAShapeLayer()
        let rightBottomPath = UIBezierPath()
        rightBottomPath.move(to: CGPoint(x:view.frame.width, y: view.frame.height-100))
        rightBottomPath.addCurve(to: CGPoint(x: view.frame.width-50, y: view.frame.height), controlPoint1: CGPoint(x:view.frame.width-5, y: view.frame.height-50), controlPoint2: CGPoint(x:view.frame.width-50, y: view.frame.height))
        rightBottomPath.addLine(to: CGPoint(x:view.frame.width, y: view.frame.height+25))
        rightBottomShape.strokeColor = UIColor.clear.cgColor
        rightBottomShape.fillColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 240/255, alpha: 1).cgColor
        rightBottomPath.close()
        rightBottomShape.path = rightBottomPath.cgPath
        view.layer.addSublayer(rightBottomShape)
        
        let leftTopShape:CAShapeLayer = CAShapeLayer()
        let leftTopPath = UIBezierPath()
        leftTopPath.move(to: CGPoint(x: 0, y: view.frame.height-300))
        leftTopPath.addCurve(to: CGPoint(x: 50, y: view.frame.height-400), controlPoint1: CGPoint(x:5, y: view.frame.height-350), controlPoint2: CGPoint(x:50, y: view.frame.height-400))
        leftTopPath.addLine(to: CGPoint(x:0, y: view.frame.height-425))
        leftTopShape.strokeColor = UIColor.clear.cgColor
        leftTopShape.fillColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 240/255, alpha: 1).cgColor
        leftTopPath.close()
        leftTopShape.path = leftTopPath.cgPath
        view.layer.addSublayer(leftTopShape)
        
        let rightTopShape:CAShapeLayer = CAShapeLayer()
        let rightTopPath = UIBezierPath()
        rightTopPath.move(to: CGPoint(x:view.frame.width, y: view.frame.height-300))
        rightTopPath.addCurve(to: CGPoint(x: view.frame.width-50, y: view.frame.height-400), controlPoint1: CGPoint(x:view.frame.width-5, y: view.frame.height-350), controlPoint2: CGPoint(x:view.frame.width-50, y: view.frame.height-400))
        rightTopPath.addLine(to: CGPoint(x:view.frame.width, y: view.frame.height-425))
        rightTopShape.strokeColor = UIColor.clear.cgColor
        rightTopShape.fillColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 240/255, alpha: 1).cgColor
        rightTopPath.close()
        rightTopShape.path = rightTopPath.cgPath
        view.layer.addSublayer(rightTopShape)
    
    }
}

extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}
