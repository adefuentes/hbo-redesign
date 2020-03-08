//
//  ViewController.swift
//  HBO
//
//  Created by Angel Fuentes on 30/09/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

class HBOViewController: UIViewController {
    
    // First Layout
    var moviesBackground: UIView!
    var imgLogin: UIImageView!
    var inputsView: UIView!
    var presentButton: UIButton!
    
    // Inputs View
    var userInput: HBOInputTextView!
    var passInput: HBOInputTextView!
    var buttonLogin: HBOLoginButton!
    var signUpButton: UIButton!
    var recoverButton: UIButton!
    
    // Const
    
    var q4: CGFloat {
        get {
            return view.frame.height * 0.45
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HBOViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HBOViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.backgroundColor = .darkBackground
        
        createImageLayout()
        createGradientLayer()
        setupViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionHideKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
        
        buttonLogin.addTarget(self, action: #selector(actionLogin(_:)), for: .touchUpInside)
        
    }


}

//Action's

extension HBOViewController {
    
    @objc func actionLogin(_ sender: UIButton) {
        
        let tabController = HBOTabController()
        
        present(tabController, animated: true, completion: nil)
        
    }
    
    @objc func actionHideKeyboard(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.inputsView.frame.origin.y == 0 {
            
            let buttonY = q4 + 140
            
            self.moviesBackground.frame.origin.y = -100
            self.inputsView.frame.origin.y = -100
            self.buttonLogin.frame.origin.y = buttonY
            self.signUpButton.frame.origin.y = buttonY
            self.recoverButton.isHidden = true
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.inputsView.frame.origin.y != 0 {
            self.moviesBackground.frame.origin.y = 0
            self.inputsView.frame.origin.y = 0
            self.buttonLogin.frame.origin.y = view.frame.height - view.safeAreaInsets.bottom - 58
            self.signUpButton.frame.origin.y = view.frame.height - view.safeAreaInsets.bottom - 58
            self.recoverButton.isHidden = false
        }
    }
    
}

// Setup's

extension HBOViewController {
    
    private func setupViews() {
        
        inputsView = UIView(frame: view.frame)
        
        imgLogin = UIImageView(image: UIImage(named: "makefg"))
        imgLogin.contentMode = .scaleAspectFit
        
        userInput = HBOInputTextView()
        passInput = HBOInputTextView()
        
        recoverButton = UIButton()
        signUpButton = UIButton()
        buttonLogin = HBOLoginButton()
        
        signUpButton.setTitle("Registrarse", for: .normal)
        signUpButton.setTitleColor(UIColor(displayP3Red: 88/255, green: 88/255, blue: 88/255, alpha: 1), for: .normal)
        signUpButton.backgroundColor = UIColor(displayP3Red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        signUpButton.layer.cornerRadius = 25
        
        recoverButton.setTitle("¿Olvidáste la contraseña?", for: .normal)
        recoverButton.setTitleColor(.white, for: .normal)
        recoverButton.titleLabel?.font = recoverButton.titleLabel?.font.withSize(18)
        
        view.addSubview(inputsView)
        view.addSubview(imgLogin)
        inputsView.addSubview(userInput)
        inputsView.addSubview(passInput)
        inputsView.addSubview(recoverButton)
        inputsView.addSubview(signUpButton)
        inputsView.addSubview(buttonLogin)
        
        userInput.input.attributedPlaceholder = NSAttributedString(string: "Usuario",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 88/255, green: 88/255, blue: 88/255, alpha: 1)])
        
        passInput.input.attributedPlaceholder = NSAttributedString(string: "Contraseña",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 88/255, green: 88/255, blue: 88/255, alpha: 1)])
        
        imgLogin.translatesAutoresizingMaskIntoConstraints = false
        userInput.translatesAutoresizingMaskIntoConstraints = false
        passInput.translatesAutoresizingMaskIntoConstraints = false
        recoverButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        buttonLogin.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": imgLogin]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0(70)]",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": imgLogin]))
        
        inputsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": userInput]))
        
        inputsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": passInput]))
        
        inputsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(q4 + 10)-[v0(50)]-[v1(50)]-16-[v2]",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": userInput, "v1": passInput, "v2": recoverButton]))
        
        inputsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]",
                                                                 options: [],
                                                                 metrics: nil,
                                                                 views: ["v0": recoverButton]))
        
        inputsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(50)]-|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": signUpButton]))
        
        inputsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(50)]-|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": buttonLogin]))
        
        inputsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-[v1(140)]-|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": signUpButton, "v1": buttonLogin]))
        
    }
    
    private func createImageLayout() {
        
        moviesBackground = UIView(frame: view.frame)
        
        let backgroundImage  = UIImageView(image: UIImage(named: "header_background-fondo"))
        let backgroundImage2 = UIImageView(image: UIImage(named: "header_background-capa-1"))
        let backgroundImage3 = UIImageView(image: UIImage(named: "header_background-capa-2"))
        let backgroundImage4 = UIImageView(image: UIImage(named: "header_background-capa-3"))
        let backgroundImage5 = UIImageView(image: UIImage(named: "header_background-capa-4"))
        
        backgroundImage.isHidden = true
        
        backgroundImage2.contentMode = .scaleAspectFill
        backgroundImage3.contentMode = .scaleAspectFill
        backgroundImage4.contentMode = .scaleAspectFill
        backgroundImage5.contentMode = .scaleAspectFill
        
        view.addSubview(moviesBackground)
        
        moviesBackground.addSubview(backgroundImage)
        moviesBackground.addSubview(backgroundImage2)
        moviesBackground.addSubview(backgroundImage3)
        moviesBackground.addSubview(backgroundImage4)
        moviesBackground.addSubview(backgroundImage5)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage2.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage3.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage4.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage5.translatesAutoresizingMaskIntoConstraints = false
        
        moviesBackground.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": backgroundImage]))
        
        moviesBackground.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(\(q4))]",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": backgroundImage]))
        
        moviesBackground.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": backgroundImage2]))
        
        moviesBackground.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(\(q4))]",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": backgroundImage2]))
        
        moviesBackground.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": backgroundImage3]))
        
        moviesBackground.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(\(q4))]",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": backgroundImage3]))
        
        moviesBackground.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": backgroundImage4]))
        
        moviesBackground.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(\(q4))]",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": backgroundImage4]))
        
        moviesBackground.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": backgroundImage5]))
        
        moviesBackground.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(\(q4))]",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": backgroundImage5]))
        
    }
    
    func createGradientLayer() {
        
        let gradientView = UIView()
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: q4)
        gradientLayer.colors = [UIColor(displayP3Red: 22/255, green: 22/255, blue: 22/255, alpha: 1).cgColor,
                                UIColor(displayP3Red: 22/255, green: 22/255, blue: 22/255, alpha: 0.8).cgColor,
                                UIColor.black.withAlphaComponent(0).cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        
        moviesBackground.addSubview(gradientView)
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        moviesBackground.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": gradientView]))
        
        moviesBackground.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(\(q4))]",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["v0": gradientView]))
        
    }
    
}
