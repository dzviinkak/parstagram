//
//  CameraViewController.swift
//  parstagram
//
//  Created by Dzvinka Koman on 10/18/20.
//

import UIKit
import AlamofireImage
import Parse

// UIImagePickerControllerDelegate allows to access camera
class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentField: UITextField!
    
    @IBAction func onSSubmit(_ sender: Any) {
        // PFO objects support different data types incl. binary objects like images
        // behave similarly to dictionaries
        let post = PFObject(className: "Posts")
        
        post["caption"] = commentField.text!
        // saves the current user as the "author"
        post["author"] = PFUser.current()
        // saves images as png (as a separate file)
        let imageData = imageView.image!.pngData()
        // createss url that leads to the saves image => allows to put it into the table on parse (i.e. in post)
        let file = PFFileObject(name: "image.png", data: imageData!)
        post["image"] = file
        
        post.saveInBackground(block: { (success,error) in
            if success{
                self.dismiss(animated: true, completion: nil)
                print("Success!")
            } else {
                print("error!")
            }
        })
    }
    
    // implements what should happen when user taps on the photo button ( gets user to library or camera)
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        // allows to call on this function when the user took the picture
        picker.delegate = self
        // presents 2nd screen to the user after the photot is taken to edit the picture (?)
        picker.allowsEditing = true
        
        // if camera is avaliable on a phone
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else { // if not available (simulator), use photo library
            picker.sourceType = .photoLibrary
        }
        // leads user to camera or to the library
        present(picker, animated: true, completion: nil)
    }
    // func that allows to use pictures taken (or from library) in the app
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        // resize it because image size from camera/library might be too big
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        imageView.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
