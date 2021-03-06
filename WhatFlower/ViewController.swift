//
//  ViewController.swift
//  WhatFlower
//
//  Created by Bo on 6/3/19.
//  Copyright © 2019 Jessica Trinh. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
        
            guard let convertedCIImage = CIImage(image: userPickedImage) else {
                fatalError("cannot convert to CIImage")
            }
            
            detect(image: convertedCIImage)
        
        imageView.image = userPickedImage
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            
            fatalError("cannot import model")
            
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            let classification = request.results?.first as? VNClassificationObservation
            
            self.navigationItem.title = classification?.identifier.capitalized
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
        try handler.perform([request])
        }
        
        catch {
            print(error)
        }
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

