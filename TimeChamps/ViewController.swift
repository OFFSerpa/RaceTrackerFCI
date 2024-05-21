//
//  ViewController.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 15/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.text = "Trajetos"
        titleLabel.font = UIFont.italicSystemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    let addButton: UIButton = {
        
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: "plus.circle", withConfiguration: config)
        
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Setting The View BackgroundColor
        self.view.backgroundColor = UIColor.secondarySystemBackground
        
        setElements()
        
    }
    
    //Configuração dos elementos da tela
    func setElements() {
        setTitle()
        setAddButton()
    }
    
    
    //Configuração do addButton
    func setAddButton() {
        view.addSubview(addButton)
        
        
        self.addButton.addTarget(self, action: #selector(navigate), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 340),
            addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            addButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5)
        ])
    }
    
    //Configuração do Titulo da tela
    func setTitle() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
    }
    //Configuração da navigate para a AddView
    @objc func navigate() {
        print("OK")
        let destination = AddViewController()
        navigationController?.pushViewController(destination, animated: true)
        
    }
    
}

extension UIFont {
    
    class func italicSystemFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular)-> UIFont {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        switch weight {
        case .ultraLight, .light, .thin, .regular:
            return font.withTraits(.traitItalic, ofSize: size)
        case .medium, .semibold, .bold, .heavy, .black:
            return font.withTraits(.traitBold, .traitItalic, ofSize: size)
        default:
            return UIFont.italicSystemFont(ofSize: size)
        }
    }
    
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits..., ofSize size: CGFloat) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: size)
    }
    
}
#Preview {
    ViewController()
}
