//
//  EditarElementoViewController.swift
//  NotasCoreDatacfe
//
//  Created by marco rodriguez on 16/08/22.
//

import UIKit
import CoreData

class EditarElementoViewController: UIViewController {
    
    @IBOutlet weak var textoNota: UITextView!
    @IBOutlet weak var imagenNota: UIImageView!
    @IBOutlet weak var fechaNota: UIDatePicker!
    
    var recibirNotaEditar: Nota?
    
    // MARK: - Contexto
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Mostrar la info del item seleccionado
        textoNota.text = recibirNotaEditar?.titulo ?? ""
        fechaNota.date = recibirNotaEditar?.fecha ?? Date.now
        let imagenData = UIImage(data: (recibirNotaEditar?.imagen)!)
        imagenNota.image = imagenData
        
        
        // MARK: - Gestura a la imagen
        //Gestura a la imagen
        let gestura = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestura.numberOfTapsRequired = 1
        gestura.numberOfTouchesRequired = 1
        imagenNota.addGestureRecognizer(gestura)
        imagenNota.isUserInteractionEnabled = true
    }
    
    @objc func clickImagen(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func cancelarButton(_ sender: Any) {
    }
    
    @IBAction func guardarButton(_ sender: Any) {
        //Que es lo que voy a guardar
        recibirNotaEditar?.titulo = textoNota.text ?? ""
        recibirNotaEditar?.fecha = fechaNota.date
        recibirNotaEditar?.imagen = imagenNota.image?.pngData()
        
        do {
            try contexto.save()
        } catch  {
            print("Error al guardar ",error.localizedDescription)
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    

}

extension EditarElementoViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
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
