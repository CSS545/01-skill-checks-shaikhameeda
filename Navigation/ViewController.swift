//
//  ViewController.swift
//  Navigation
//
//  Created by hameeda shaik on 07/10/22.
//

import UIKit

class ViewController: UIViewController

  {
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title="HELLO WORLD"
        //The Background Color
        view.backgroundColor = .cyan
        //Button Dimensions
        let button = UIButton(frame: CGRect(x:1, y:1, width:215, height: 55))
        view.addSubview(button)
        //the position of the button
        button.center = view.center
        button.backgroundColor = .black
        button.backgroundColor = .systemBlue
        button.setTitle("Please click here ",for: .normal)
        button.addTarget(self, action: #selector(Button), for: .touchUpInside)
        configureItems()
    }
    private func configureItems()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        
    }
    //We are calling the function button
    @objc func Button()
    {
        let vc = UIViewController()
        vc.title = "This is second page"
        vc.view.backgroundColor = .systemGreen
    
        
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title : "Welcome", style: .done,target : self,action: nil)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
