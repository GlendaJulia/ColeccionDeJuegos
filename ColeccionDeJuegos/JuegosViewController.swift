//
//  JuegosViewController.swift
//  ColeccionDeJuegos
//
//  Created by Tecsup on 25/04/19.
//  Copyright © 2019 Glenda. All rights reserved.
//

import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let salutations = ["Pelicula", "Viaje", "Memes", "Familia"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return salutations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return salutations[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textBox.text = salutations[row]
        self.pickerTextField.isHidden = true
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        if textField == self.textBox{
            self.pickerTextField.isHidden = true
            textField.endEditing(true)
        }
    }

    @IBOutlet weak var pickerTextField: UIPickerView!
    @IBOutlet weak var s: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    @IBOutlet weak var eliminarBoton: UIButton!
    @IBOutlet weak var textBox: UITextField!
    var juego:Juego? = nil
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        if juego != nil {
            s.image = UIImage(data: (juego!.imagen!) as Data)
            tituloTextField.text = juego!.titulo
            textBox.text = juego!.categoria
            agregarActualizarBoton.setTitle("Actualizar", for: .normal)
        }else{
            eliminarBoton.isHidden = true
        }
        let pickerView = UIPickerView()
        pickerTextField.delegate = self
        pickerTextField.dataSource = self
    }
    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(juego!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        if juego != nil {
            juego!.titulo! = tituloTextField.text!
            juego!.imagen = s.image?.jpegData(compressionQuality: 0.50)
            juego!.categoria! = textBox.text!
        }else{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = Juego(context: context)
            juego.titulo = tituloTextField.text
            juego.imagen = s.image?.jpegData(compressionQuality: 0.50)
            juego.categoria = textBox.text
            
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        s.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
    }

}
