//
//  ViewController.swift
//  NotasCoreDatacfe
//
//  Created by marco rodriguez on 16/08/22.
//

import UIKit
import CoreData

class ListaNotasViewController: UIViewController {
    
    // MARK: - Contexto a la BD
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Variables
    var notas = [Nota]()
    var notaEditar: Nota?
    
    @IBOutlet weak var tablaNotas: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablaNotas.delegate = self
        tablaNotas.dataSource = self
    }
    
    //Recargar la tabla
    override func viewWillAppear(_ animated: Bool) {
        leerNotas()
    }
    
    func leerNotas(){
        let solicitud : NSFetchRequest<Nota> = Nota.fetchRequest()
        do {
            notas =  try contexto.fetch(solicitud)
            print("Se leyo correctamente de la BD!")
        } catch  {
            print("Error al leer bd")
        }
        tablaNotas.reloadData()
    }
}

extension ListaNotasViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .normal, title: "borrar") { _, _, _ in
            self.contexto.delete(self.notas[indexPath.row])
            self.notas.remove(at: indexPath.row)
            
            do{
                try self.contexto.save()
            }catch{
                print("Error al guardar en core data: \(error.localizedDescription)")
            }
            self.tablaNotas.reloadData()
        }
        accionEliminar.image = UIImage(systemName: "trash")
        accionEliminar.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaNotas.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        celda.textLabel?.text = notas[indexPath.row].titulo
        celda.detailTextLabel?.text = "\(notas[indexPath.row].fecha ?? Date.now)"
        //Mostrar la imgen de la bd
        let imagenBD = UIImage(data: notas[indexPath.row].imagen!)
        celda.imageView?.image = imagenBD
        celda.imageView?.layer.cornerRadius = 20
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notaEditar = notas[indexPath.row]
        
        performSegue(withIdentifier: "editar", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar"{
            let objDestino = segue.destination as! EditarElementoViewController
            objDestino.recibirNotaEditar = notaEditar
        }
    }
    
}
