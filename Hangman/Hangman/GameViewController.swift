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
    
    var numIncorrect = 0

    let placeHolderChar: Character = "-"
    var hangmanPhraseString: String = ""
    var incorrectGuessesArray = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
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
        print(phrase)
        guessButton.addTarget(self, action: "guessButtonTap", forControlEvents: .TouchUpInside)
    
        hangmanStateImage.image = UIImage(named: "hangman1.gif")
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isWinState() -> Bool {
        return !hangmanPhraseLabel.text!.characters.contains(placeHolderChar)
    }
    
    func isLoseState() -> Bool {
        return numIncorrect >= 7
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
        let guessChar: Character = (phraseGuessTextField.text?.characters[(phraseGuessTextField.text?.characters.startIndex)!])!
        var tempString = hangmanPhraseLabel.text
        if hangmanPhraseString.characters.contains(guessChar) {
            for index in (tempString!.characters.indices) {
                if hangmanPhraseString.characters[index] == guessChar && tempString?.characters[index] == placeHolderChar {
                    tempString?.removeAtIndex(index)
                    tempString?.insert(guessChar, atIndex: index)
                }
            }
            hangmanPhraseLabel.text = tempString
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
            if !isLoseState() {
                setHangmanStateImage()
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
