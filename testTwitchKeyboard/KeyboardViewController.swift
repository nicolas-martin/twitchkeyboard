//
//  KeyboardViewController.swift
//  testTwitchKeyboard
//
//  Created by Nicolas Martin on 2016-09-05.
//  Copyright © 2016 Nicolas Martin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    func createButtonWithTitle(title: String) -> UIButton {
        
        let button = UIButton(type: .System)
        button.frame = CGRectMake(0, 0, 20, 20)
        button.setTitle(title, forState: .Normal)
        button.sizeToFit()
        button.titleLabel!.font = UIFont.systemFontOfSize(15)
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        //        button.af_setImageForState(.Normal, URL: NSURL(fileURLWithPath: "https://static-cdn.jtvnw.net/emoticons/v1/78426/3.0"))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(KeyboardViewController.didTapButton(_:)), forControlEvents: .TouchUpInside)
        
        return button
    }
    
    func didTapButton(sender: AnyObject?) {
        
        let button = sender as! UIButton
        let title = button.titleForState(.Normal)!
        let proxy = textDocumentProxy as UITextDocumentProxy
        
        proxy.insertText(title)
        
        switch title {
        case "BP" :
            proxy.deleteBackward()
        case "RETURN" :
            proxy.insertText("\n")
        case "SPACE" :
            proxy.insertText(" ")
        case "CHG" :
            self.advanceToNextInputMode()
        default :
            proxy.insertText(title)
        }
    }
    
    func createRowOfButtons(buttonTitles: [NSString]) -> UIView {
        var buttons = [UIButton]()
        let keyboardRowView = UIView(frame: CGRectMake(0, 0, 320, 50))
        
        for buttonTitle in buttonTitles{
            let button = createButtonWithTitle(buttonTitle as String)
            buttons.append(button)
            keyboardRowView.addSubview(button)
        }
        
        addIndividualButtonConstraints(buttons, mainView: keyboardRowView)
        
        keyboardRowView.translatesAutoresizingMaskIntoConstraints = false
        return keyboardRowView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonTitles1 = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        let buttonTitles2 = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
        let buttonTitles3 = ["CP", "Z", "X", "C", "V", "B", "N", "M", "BP"]
        let buttonTitles4 = ["CHG", "SPACE", "RETURN"]
        
        let row1 = createRowOfButtons(buttonTitles1)
        let row2 = createRowOfButtons(buttonTitles2)
        let row3 = createRowOfButtons(buttonTitles3)
        let row4 = createRowOfButtons(buttonTitles4)
        
        self.view.addSubview(row1)
        self.view.addSubview(row2)
        self.view.addSubview(row3)
        self.view.addSubview(row4)
        
        addConstraintsToInputView(self.view, rowViews: [row1, row2, row3, row4])
        
        //        // Perform custom UI setup here
        //        self.nextKeyboardButton = UIButton(type: .System)
        //
        //        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        //        self.nextKeyboardButton.sizeToFit()
        //        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        //
        //        self.nextKeyboardButton.addTarget(self, action: #selector(advanceToNextInputMode), forControlEvents: .TouchUpInside)
        //
        //        self.view.addSubview(self.nextKeyboardButton)
        //
        //        self.nextKeyboardButton.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
        //        self.nextKeyboardButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
    }
    
    func addConstraintsToInputView(inputView: UIView, rowViews: [UIView]){
        
        for (index, rowView) in rowViews.enumerate() {
            let rightSideConstraint = NSLayoutConstraint(item: rowView, attribute: .Right, relatedBy: .Equal, toItem: inputView, attribute: .Right, multiplier: 1.0, constant: -1)
            
            let leftConstraint = NSLayoutConstraint(item: rowView, attribute: .Left, relatedBy: .Equal, toItem: inputView, attribute: .Left, multiplier: 1.0, constant: 1)
            
            inputView.addConstraints([leftConstraint, rightSideConstraint])
            
            var topConstraint: NSLayoutConstraint
            
            if index == 0 {
                topConstraint = NSLayoutConstraint(item: rowView, attribute: .Top, relatedBy: .Equal, toItem: inputView, attribute: .Top, multiplier: 1.0, constant: 0)
                
            }else{
                
                let prevRow = rowViews[index-1]
                topConstraint = NSLayoutConstraint(item: rowView, attribute: .Top, relatedBy: .Equal, toItem: prevRow, attribute: .Bottom, multiplier: 1.0, constant: 0)
                
                let firstRow = rowViews[0]
                let heightConstraint = NSLayoutConstraint(item: firstRow, attribute: .Height, relatedBy: .Equal, toItem: rowView, attribute: .Height, multiplier: 1.0, constant: 0)
                
                inputView.addConstraint(heightConstraint)
            }
            inputView.addConstraint(topConstraint)
            
            var bottomConstraint: NSLayoutConstraint
            
            if index == rowViews.count - 1 {
                bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .Bottom, relatedBy: .Equal, toItem: inputView, attribute: .Bottom, multiplier: 1.0, constant: 0)
                
            }else{
                
                let nextRow = rowViews[index+1]
                bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .Bottom, relatedBy: .Equal, toItem: nextRow, attribute: .Top, multiplier: 1.0, constant: 0)
            }
            
            inputView.addConstraint(bottomConstraint)
        }
        
    }
    
    func addIndividualButtonConstraints(buttons: [UIButton], mainView: UIView){
        
        for (index, button) in buttons.enumerate(){
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: 1)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: -1)
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == buttons.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: mainView, attribute: .Right, multiplier: 1.0, constant: -1)
                
            }else{
                
                let nextButton = buttons[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: nextButton, attribute: .Left, multiplier: 1.0, constant: -1)
            }
            
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: mainView, attribute: .Left, multiplier: 1.0, constant: 1)
                
            }else{
                
                let prevtButton = buttons[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prevtButton, attribute: .Right, multiplier: 1.0, constant: 1)
                
                let firstButton = buttons[0]
                let widthConstraint = NSLayoutConstraint(item: firstButton, attribute: .Width, relatedBy: .Equal, toItem: button, attribute: .Width, multiplier: 1.0, constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    //    override func textDidChange(textInput: UITextInput?) {
    //        // The app has just changed the document's contents, the document context has been updated.
    //
    //        var textColor: UIColor
    //        let proxy = self.textDocumentProxy
    //        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
    //            textColor = UIColor.whiteColor()
    //        } else {
    //            textColor = UIColor.blackColor()
    //        }
    //        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    //    }
    
}
