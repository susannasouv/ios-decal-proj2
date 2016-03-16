//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var hangmanStateImage: UIImageView!
    @IBOutlet weak var hangmanPhraseLabel: UILabel!
    @IBOutlet weak var phraseGuessTextField: UITextField!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    @IBOutlet weak var guessButton: UIButton!
    @IBAction func quitGame(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func startOver(sender: AnyObject) {
        setUpPuzzle(hangmanPhraseString)
    }
    
    var numIncorrect = 0

    let placeHolderChar: Character = "-"
    var hangmanPhraseString: String = ""
    var incorrectGuessesArray = [Character]()
    
    var winAlert = UIAlertController(title: "You win!",
                                     message: "Good job!",
                                     preferredStyle: UIAlertControllerStyle.Alert)

    
    var loseAlert = UIAlertController(title: "You lost...",
                                      message: "LOL you suck",
                                      preferredStyle: UIAlertControllerStyle.Alert)
    var invalidInputAlert = UIAlertController(title: "Invalid Input",
                                              message: "Please only input one letter at a time",
                                              preferredStyle: UIAlertControllerStyle.Alert)
    
    func setUpPuzzle (phrase:String) {
        print(phrase)
        numIncorrect = 0
        incorrectGuessesArray = [Character]()
        incorrectGuessesLabel.text = "Incorrect guesses: \n"
        hangmanPhraseString = phrase
        var hangmanPhraseText = ""
        for index in phrase.characters.indices {
            if phrase[index] == " " {
                hangmanPhraseText.append(Character(" "))
            }
            else {
                hangmanPhraseText.append(placeHolderChar)
            }
        }
        hangmanPhraseLabel.text = hangmanPhraseText
        hangmanStateImage.image = UIImage(named: "hangman1.gif")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()

        setUpPuzzle(phrase)
        guessButton.addTarget(self, action: "guessButtonTap", forControlEvents: .TouchUpInside)
        let newGameAction = UIAlertAction(title: "New game", style: .Default) {
            (action: UIAlertAction!) in
            let phrase = hangmanPhrases.getRandomPhrase()
            self.setUpPuzzle(phrase)
        }
        winAlert.addAction(newGameAction)
        let restartGameAction = UIAlertAction(title: "Try again",  style: .Default) {
            (action: UIAlertAction!) in self.setUpPuzzle(self.hangmanPhraseString)
        }
        loseAlert.addAction(restartGameAction)
        loseAlert.addAction(newGameAction)
        let okayAction = UIAlertAction(title: "Ok", style:. Default) {
            (action: UIAlertAction!) in self.phraseGuessTextField.text = ""
        }
        invalidInputAlert.addAction(okayAction)

        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isWinState() -> Bool {
        return !hangmanPhraseLabel.text!.characters.contains(placeHolderChar)
    }
    
    func isLoseState() -> Bool {
        return numIncorrect >= 6
    }

    func setHangmanStateImage() {
        // going to assume that numIncorrect < 7
        var imageName = "hangman"
        imageName.insertContentsOf(String(numIncorrect + 1).characters, at: imageName.endIndex)
        imageName.insertContentsOf(".gif".characters, at: imageName.endIndex)
        hangmanStateImage.image = UIImage(named: imageName)
    }
    
    func correctButtonTap () {
        // removes the first placeHolderChar in hangmanPhraseLabel.text
        if let phraseSoFar = hangmanPhraseLabel.text {
            for index in phraseSoFar.characters.indices {
                if phraseSoFar[index] == placeHolderChar {
                    hangmanPhraseLabel.text!.removeAtIndex(index)
                    hangmanPhraseLabel.text!.insert(hangmanPhraseString[index], atIndex: index)
//                    hangmanPhraseLabel.text!.removeAtIndex(index.successor())
// above line, combined with the line above it does not work for some reason
                    return
                }
            }
        }

        
    }
    
    func incorrectButtonTap () {
        if let phraseGuessTextFieldContent = phraseGuessTextField.text {
            if phraseGuessTextFieldContent.isEmpty {
                return
            }
        }
        let guessChar: Character = (phraseGuessTextField.text?.characters[(phraseGuessTextField.text?.characters.startIndex)!])!
        updateIncorrectGuesses(guessChar)
    }
    
    func guessButtonTap() {
        if let phraseGuessTextFieldContent = phraseGuessTextField.text {
            if phraseGuessTextFieldContent.isEmpty {
                return
            }
            
        }
        let guessString: String = (phraseGuessTextField.text)!
        if guessString.characters.count != 1 {
            presentViewController(invalidInputAlert, animated: true, completion: nil)
            return
        }
        let guessChar: Character = (phraseGuessTextField.text?.uppercaseString.characters[(phraseGuessTextField.text?.characters.startIndex)!])!
        let validCharSet = NSCharacterSet.letterCharacterSet()
        if (guessString.rangeOfCharacterFromSet(validCharSet) == nil) {
            presentViewController(invalidInputAlert, animated: true, completion: nil)
            return
        }
        var tempString = hangmanPhraseLabel.text
        if hangmanPhraseString.characters.contains(guessChar) {
            for index in (tempString!.characters.indices) {
                if hangmanPhraseString.characters[index] == guessChar && tempString?.characters[index] == placeHolderChar {
                    tempString?.removeAtIndex(index)
                    tempString?.insert(guessChar, atIndex: index)
                }
            }
            hangmanPhraseLabel.text = tempString
            if isWinState() {
                presentViewController(winAlert, animated: true, completion: nil)
            }
        }
        else {
            updateIncorrectGuesses(guessChar)
        }
        phraseGuessTextField.text = ""
    }
    
    func updateIncorrectGuesses(guessChar : Character) {
        if incorrectGuessesArray.contains(guessChar) {
            return
        }
        else {
            numIncorrect += 1
            incorrectGuessesArray.append(guessChar)
            incorrectGuessesLabel.text = "Incorrect guesses: \n"
            for incorrectGuess in incorrectGuessesArray {
                incorrectGuessesLabel.text?.append(incorrectGuess)
                incorrectGuessesLabel.text?.append(Character(" "))
            }
            setHangmanStateImage()
            if isLoseState() {
                presentViewController(loseAlert, animated: true, completion: nil)
            }

        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
