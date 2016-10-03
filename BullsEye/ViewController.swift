//
//  ViewController.swift
//  BullsEye
//
//  Created by Matthijs on 22/06/2016.
//  Copyright © 2016 Razeware. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!

    @IBOutlet weak var operation: UILabel!
    @IBOutlet weak var sliderTwo: UISlider!
    @IBOutlet weak var minValueSlider: UILabel!
    @IBOutlet weak var maxValueSlider: UILabel!
    @IBOutlet weak var minValueSliderTwo: UILabel!
    @IBOutlet weak var maxValueSliderTwo: UILabel!
    
  var currentValue = 0
    var currentValue2 = 0
    var options = ["+","-","*","/"]
  var targetValue = 0
  var score = 0
  var round = 0
    
    

  override func viewDidLoad() {
    super.viewDidLoad()
    startNewGame()
    updateLabels()
    
    let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
    slider.setThumbImage(thumbImageNormal, for: .normal)
    sliderTwo.setThumbImage(thumbImageNormal, for: .normal)
    
    let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
    slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
    sliderTwo.setThumbImage(thumbImageHighlighted, for: .highlighted)
    
    let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    
    let trackLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
    let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
    slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
    sliderTwo.setMinimumTrackImage(trackLeftResizable, for: .normal)
    
    let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
    let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
    slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    sliderTwo.setMaximumTrackImage(trackRightResizable, for: .normal)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func showAlert() {
    var goalNumber = 0
    
    if operation.text == "+" {
      goalNumber = currentValue + currentValue2
      print("hit:\(goalNumber)")
    }
    else if operation.text == "-" {
      goalNumber = currentValue - currentValue2
      print("hit:\(goalNumber)")
    }
    else if operation.text == "*" {
      goalNumber = currentValue * currentValue2
      print("hit:\(goalNumber)")
    }
    else {
      goalNumber = currentValue / currentValue2
      print("hit:\(goalNumber)")
    }

    let difference = abs(targetValue - goalNumber)
    var points = 100 - difference
    
    let title: String
    if difference == 0 {
      title = "Perfect!"
      points += 100
    } else if difference < 5 {
      title = "You almost had it!"
      if difference == 1 {
        points += 50
      }
    } else if difference < 10 {
      title = "Pretty good!"
    } else {
      title = "Not even close..."
    }
    
    score += points
    
    let message = "You scored \(points) points"
    
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default,
                               handler: { action in
                                self.startNewRound()
                                self.updateLabels()
                               })

    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func sliderMoved(_ slider: UISlider) {
    currentValue = lroundf(slider.value)
    print("Slider value: \(slider.value)")
  }
  
    @IBAction func sliderMovedTwo(_ sliderTwo: UISlider) {
        currentValue2 = lroundf(sliderTwo.value)
      print("SliderTwo value: \(sliderTwo.value)")
    }
    
    
  @IBAction func startOver() {
    startNewGame()
    updateLabels()
    
    let transition = CATransition()
    transition.type = kCATransitionFade
    transition.duration = 1
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    view.layer.add(transition, forKey: nil)
  }

  func startNewGame() {
    score = 0
    round = 0
    startNewRound()
  }
  
  func startNewRound() {
    round += 1
    
    operation.text = options[Int(arc4random_uniform(UInt32(options.count)))]
    
    slider.minimumValue = Float(50 + Int(arc4random_uniform(50)))
    slider.maximumValue = Float(100 + Int(arc4random_uniform(50)))
    sliderTwo.minimumValue = Float(1 + Int(arc4random_uniform(50)))
    sliderTwo.maximumValue = Float(50 + Int(arc4random_uniform(50)))
    
    minValueSlider.text = String(slider.minimumValue)
    maxValueSlider.text = String(slider.maximumValue)
    minValueSliderTwo.text = String(sliderTwo.minimumValue)
    maxValueSliderTwo.text = String(sliderTwo.maximumValue)
    
    let targetSum = (slider.minimumValue + sliderTwo.minimumValue) + Float(arc4random_uniform(UInt32(slider.maximumValue - slider.minimumValue + sliderTwo.maximumValue - sliderTwo.minimumValue)))
    let targetLess = (slider.minimumValue - sliderTwo.maximumValue) + Float(arc4random_uniform(UInt32((slider.maximumValue - slider.minimumValue) + (sliderTwo.maximumValue - sliderTwo.minimumValue))))
    let targetMulti = (slider.minimumValue * sliderTwo.minimumValue) + Float(arc4random_uniform(UInt32((slider.maximumValue - slider.minimumValue) * (sliderTwo.maximumValue - sliderTwo.minimumValue))))
    let targetDiv = (slider.minimumValue / sliderTwo.maximumValue) + Float(arc4random_uniform(UInt32(slider.maximumValue / sliderTwo.minimumValue - slider.minimumValue / sliderTwo.maximumValue)))
    
    if operation.text == "+" {
     targetValue = Int(targetSum)
      print(targetValue)
    }
    else if operation.text == "-" {
      targetValue = Int(targetLess) 
      print(targetValue)
    }
    else if operation.text == "*" {
      targetValue = Int(targetMulti)
      print(targetValue)
    }
    else {
      targetValue = Int(targetDiv)
      print(targetValue)
    }
  
    slider.value = Float(slider.minimumValue)
    currentValue = Int(slider.value)
    print(currentValue)

    sliderTwo.value = Float(sliderTwo.minimumValue)
    currentValue2 = Int(sliderTwo.value)
    print(currentValue2)
    
    
  }
  
  func updateLabels() {
    targetLabel.text = String(targetValue)
    scoreLabel.text = String(score)
    roundLabel.text = String(round)
  }
}
