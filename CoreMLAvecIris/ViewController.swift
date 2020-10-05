//
//  ViewController.swift
//  CoreMLAvecIris
//
//  Created by Rodolphe DUPUY on 05/10/2020.
//  Copyright © 2018 Rodolphe DUPUY. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {
    
    @IBOutlet weak var resultatLbl: UILabel!
    @IBOutlet weak var bouton: UIButton!
    @IBOutlet weak var holderVue: UIView!
    @IBOutlet weak var irisImageVue: UIImageView!
    
    @IBOutlet weak var longueurSepaleLbl: UILabel!
    @IBOutlet weak var largeurSepaleLbl: UILabel!
    @IBOutlet weak var longueurPetaleLbl: UILabel!
    @IBOutlet weak var largeurPetaleLbl: UILabel!
    
    @IBOutlet weak var longueurSepaleSlider: UISlider!
    @IBOutlet weak var largeurSepaleSlider: UISlider!
    @IBOutlet weak var longueurPetaleSlider: UISlider!
    @IBOutlet weak var largeurPetaleSlider: UISlider!
    
    var imageVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultatLbl.text = ""
        changerTitre()
    }
    
    func animation() {
        irisImageVue.isHidden = imageVisible
        UIView.transition(with: holderVue, duration: 0.5, options: .transitionFlipFromRight, animations: nil) { (success) in
            self.imageVisible = !self.imageVisible
            self.changerTitre()
        }
    }
    
    func changerTitre() {
        if imageVisible {
            bouton.setTitle("Essayer à nouveau", for: .normal)
        } else {
            bouton.setTitle("Lancer CoreML", for: .normal)
        }
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        guard let slider = sender as? UISlider else { return }
        let valeurString = String(format: "%.1f", slider.value)
        switch slider.tag {
        case 0: longueurSepaleLbl.text = "Longueur des sépales: " + valeurString
        case 1: largeurSepaleLbl.text = "Largeur des sépales: " + valeurString
        case 2: longueurPetaleLbl.text = "Longueur des pétales: " + valeurString
        case 3: largeurPetaleLbl.text = "Largeur des pétales: " + valeurString
        default: break
        }
    }
    
    @IBAction func boutonAction(_ sender: Any) {
        if !imageVisible {
            do {
                let config = MLModelConfiguration()
                let model = try mon_iris_model(configuration: config)
                let input = mon_iris_modelInput(
                    sepal_length__cm_: Double(longueurSepaleSlider.value),
                    sepal_width__cm_: Double(largeurSepaleSlider.value),
                    petal_length__cm_: Double(longueurPetaleSlider.value),
                    petal_width__cm_: Double(largeurPetaleSlider.value))
                let prediction = try model.prediction(input: input)
                let resultatInt = Int(prediction.espece)
                let image = UIImage(named: String(resultatInt))
                irisImageVue.image = image
                switch resultatInt {
                case 0: resultatLbl.text = "Iris Setosa"
                case 1: resultatLbl.text = "Iris Versicolor"
                case 2: resultatLbl.text = "Iris Virginica"
                default: break
                }
                animation()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            animation()
        }
    }
    
}

