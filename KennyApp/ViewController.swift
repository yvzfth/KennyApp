//
//  ViewController.swift
//  KennyApp
//
//  Created by Fatih Yavuz on 11.06.2023.
//

import UIKit

class ViewController: UIViewController {
    let gamePlaySeconds = 10
    var randomX = 0.0
    var randomY = 0.0
    var countdownTimer: Timer?
    var kennyTimer: Timer?
    var remainingSeconds = 0
    var score = 0
    var highscore = 0
    
    @IBOutlet var parentView: UIView!
    @IBOutlet var highscoreLabel: UILabel!
    var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    var imageViewHalfWidth = 0.0
    var imageViewHalfHeight = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageViewHalfWidth = Double(imageView.frame.width/2)
        imageViewHalfHeight = Double(imageView.frame.height/2)
        timeLabel.text = String(gamePlaySeconds)
        
        if let storedHighScore = UserDefaults.standard.object(forKey: "highscore") {
            highscore = storedHighScore as! Int
            highscoreLabel.text = "Highscore: \(storedHighScore)"
        }
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
       
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        // Perform actions when the image view is tapped
        UIImageView.animate(withDuration: 0.4, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                               self.imageView.alpha = 0
           }) { (_) in
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                   self.imageView.transform = CGAffineTransform.identity
                   self.imageView.alpha = 1
                   self.imageView.isHidden = false
               }
           }
        score += 1
        scoreLabel.text = "Score: \(score)"
        
    }
    
    @IBAction func startCountdown() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func moveKenny() {
        
        kennyTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateKennyPositions), userInfo: nil, repeats: true)
    }
    @objc func updateKennyPositions() {
        if remainingSeconds > 0 {
            randomX = Double.random(in: imageViewHalfWidth...Double(parentView.frame.width - imageViewHalfWidth))
            randomY = Double.random(in: imageViewHalfHeight...Double(parentView.frame.height - imageViewHalfHeight))
            imageView.layer.position.x = randomX
            imageView.layer.position.y = randomY
           // imageView.isHidden = false
        }
        else {
            //imageView.isHidden = false
            kennyTimer?.invalidate()
            
        }
    }
    
    @objc func updateTimer() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            // Update countdown label or perform other actions
            timeLabel.text = String(remainingSeconds)
        } else {
            imageView.removeGestureRecognizer(tapGestureRecognizer)
            countdownTimer?.invalidate() // Stop the timer
            // Countdown has reached zero, perform any desired actions
            if(score > highscore) {
            highscore = score
                highscoreLabel.text = "Highscore: \(highscore)"
            }
            UserDefaults.standard.set(highscore, forKey: "highscore")
            let alert = UIAlertController(title: "Time's Up", message: "Would you like to replay?", preferredStyle: .alert)

                   let okAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                       // OK button action
                       self.startButton.isHidden = false
                   }
                   alert.addAction(okAction)

                   let replyAction = UIAlertAction(title: "Replay", style: .default) { _ in
                       // Reply button action
                       self.play()
                       
                   }
                   alert.addAction(replyAction)

                   present(alert, animated: true, completion: nil)
        }
    }
    @IBOutlet var startButton: UIButton!
    @IBAction func startClicked(_ sender: Any) {
     play()
    }
    
    func play(){
        score = 0
        scoreLabel.text = "Score: \(score)"
        timeLabel.text = String(gamePlaySeconds)
        remainingSeconds = gamePlaySeconds
        startCountdown()
        moveKenny()
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        startButton.isHidden = true
    }
}
