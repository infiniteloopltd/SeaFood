//
//  ViewController.swift
//  SeaFood
//
//  Created by Fiach Reid on 15/04/2018.
//  Copyright © 2018 Fiach Reid. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        let userPickedimage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = userPickedimage
        guard let ciImage = CIImage(image: userPickedimage!) else
        {
            fatalError("failed to create ciImage")
        }
        detect(image: ciImage)
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image : CIImage)
    {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else
        {
            fatalError("Failed to covert ML model")
        }
        
        var request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else
            {
                fatalError("Failed to cast to VNClassificationObservation")
            }
            print(results)
        }
        
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

