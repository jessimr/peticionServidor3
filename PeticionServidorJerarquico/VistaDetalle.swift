//
//  VistaDetalle.swift
//  PeticionServidorJerarquico
//
//  Created by JESSICA MENDOZA RUIZ on 25/03/2017.
//  Copyright © 2017 JESSICA MENDOZA RUIZ. All rights reserved.
//

import UIKit
import CoreData

class VistaDetalle: UIViewController {
    
    var libro: String = ""

    @IBOutlet weak var isbn: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autores: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    //var nombres: String = ""
    
    var contexto: NSManagedObjectContext? = nil
    var nombre: String = ""
    var escritores: String = ""
    var imagen: UIImage? = nil
    var isbnLibro: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        contexto = appDelegate.persistentContainer.viewContext
        
        //---->Leer datos de la base de datos
        let libroEntidad = NSEntityDescription.entity(forEntityName: "Libro", in: self.contexto!)
        let peticion = libroEntidad?.managedObjectModel.fetchRequestFromTemplate(withName: "petLibroTitulo", substitutionVariables: ["titulo": libro])
        do{
            let librosEntidad = try (self.contexto?.fetch(peticion!))! as! [Libro]
            for libroEntidad2 in librosEntidad{
                nombre = libroEntidad2.value(forKey: "titulo") as! String
                isbnLibro = libroEntidad2.value(forKey: "isbn") as! String
                escritores = libroEntidad2.value(forKey: "autores") as! String
                if libroEntidad2.value(forKey: "portada") != nil{
                    imagen = UIImage(data: (libroEntidad2.value(forKey: "portada") as! NSData) as Data)
                }
            }
        }catch{
        }
        
        //Mostrar datos por la app
        self.isbn.text = "ISBN: \(isbnLibro)"
        self.titulo.text = "Título: \(nombre)"
        self.autores.text = "Autor/es: \(escritores)"
        self.portada.image = imagen
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
