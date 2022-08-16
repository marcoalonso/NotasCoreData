//
//  NuevoElementoViewController.swift
//  NotasCoreDatacfe
//
//  Created by marco rodriguez on 16/08/22.
//

import UIKit
import CoreData

class NuevoElementoViewController: UIViewController {

    
    @IBOutlet weak var textoNota: UITextField!
    @IBOutlet weak var imagenNota: UIImageView!
    @IBOutlet weak var fechaNota: UIDatePicker!
    
    // MARK: - Variables
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Gestura a la imagen
        let gestura = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestura.numberOfTapsRequired = 1
        gestura.numberOfTouchesRequired = 1
        imagenNota.addGestureRecognizer(gestura)
        imagenNota.isUserInteractionEnabled = true
        
    }
    
    @objc func clickImagen(){
        print("Click Imagen")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = false //true
        present(vc, animated: true)
    }
    
    func guardarContexto(){
        do {
            try contexto.save()
        } catch  {
            print("Error al guardar en core data", error.localizedDescription)
        }
    }
    
    @IBAction func cancelarButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func guardarButton(_ sender: UIButton) {
        //que necesito hacer antes de guardar una nueva tarea
        //Obtener los datos de TF y el DatePicker
        if let tituloNota = textoNota.text, !tituloNota.isEmpty {
            let fechaP = fechaNota.date
            
            //Crear la nueva tarea a guardar
            let nuevaNota = Nota(context: self.contexto)
            
            nuevaNota.titulo = tituloNota
            nuevaNota.fecha = fechaP
            nuevaNota.imagen = imagenNota.image?.pngData()
            
            guardarContexto()
            navigationController?.popToRootViewController(animated: true)
            
        }
        
        
        
        //GuardarContexto
    }
    
}

extension NuevoElementoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Que vamos a hacer una vez que se selecciona una imagen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Se selecciono una image")
        
        //Sin recortar imagen
        imagenNota.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        //Si recortamos la imagen
        if let imagenSeleccionada = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imagenNota.image = imagenSeleccionada
        }
        
        picker.dismiss(animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        print("operacion cancelada")
    }

}
