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
        
        imagePicker.dismiss(animated: true) {
            self.detect(image: ciImage)
        }
    }
    
    func detect(image : CIImage)
    {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else
        {
            fatalError("Failed to covert ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else
            {
                fatalError("Failed to cast to VNClassificationObservation")
            }
            
            print(results)
            
           
            self.ShowMessage(title: "I see a...", message: results[0].identifier, controller: self)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do
        {
            try handler.perform([request])
        }
        catch
        {
            print("\(error)")
        }
        
    }
    
    func ShowMessage(title: String, message : String, controller : UIViewController)
    {
        let cancelText = NSLocalizedString("Cancel", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

