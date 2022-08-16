//
//  EditarElementoViewController.swift
//  NotasCoreDatacfe
//
//  Created by marco rodriguez on 16/08/22.
//

import UIKit

class EditarElementoViewController: UIViewController {
    
    @IBOutlet weak var textoNota: UITextView!
    @IBOutlet weak var imagenNota: UIImageView!
    @IBOutlet weak var fechaNota: UIDatePicker!
    
    var recibirNotaEditar: Nota?

    override func viewDidLoad() {
        super.viewDidLoad()

        //Ejercicio: Mostrar los elementos del item seleccionado
        
    }
    

}
