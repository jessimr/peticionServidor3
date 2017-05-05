//
//  ViewController.swift
//  PeticionServidorJerarquico
//
//  Created by JESSICA MENDOZA RUIZ on 25/03/2017.
//  Copyright © 2017 JESSICA MENDOZA RUIZ. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var portadaLibro: UIImageView!
    @IBOutlet weak var autoresLibro: UILabel!

    
    /*var names: [String] = []
    var arrayLibros: [datosLibro] = []
    var aux: datosLibro = datosLibro()*/
    
    var contexto: NSManagedObjectContext? = nil
    var nombre: String = ""
    var escritores: String = ""
    var portada: UIImage? = nil
    var isbnLibro: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.returnKeyType = UIReturnKeyType.search
        
        
        //Inicializa contexto
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        contexto = appDelegate.persistentContainer.viewContext
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sincrono (texto: String){
        
        //Dir servidor
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(texto)"
        //Convertir la dir en URL
        let url = NSURL(string: urls)
        //Peticion al servidor, esperar respuesta y asociarla a la variable data
        let datos: NSData? = NSData(contentsOf: url! as URL)
        
        
        if (datos != nil){
            do{
                
                let json = try JSONSerialization.jsonObject(with: datos as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! AnyObject
                print(json)
                
                if let isbn = json["ISBN:\(self.textField.text!)"] as? [String : AnyObject]{
                    //aux.isbn = self.textField.text!
                    isbnLibro = self.textField.text!
                    if let titulo = isbn["title"] as? String {
                        //print(titulo)
                        self.titulo.text = titulo as! String?
                        //aux.titulo = self.titulo.text!
                        nombre = self.titulo.text!
                    }
                    
                    if let autores = isbn["authors"] {
                        for index in 0...autores.count-1 {
                            
                            let nombre = autores[index] as! [String : AnyObject]
                            
                            //names.append(nombre["name"] as! String)
                            let name = nombre["name"] as! String
                            escritores = escritores + " " + name
                            
                        }
                        self.autoresLibro.text = escritores
                        //self.listaAutores.reloadData()
                        //aux.autores = names
                        //print (names)
                        
                    }
                    if let portada = isbn["cover"] as? [String : AnyObject] {
                        if let imagen = portada["small"] as? String {
                            let urlImagen = URL(string: imagen)
                            let dataImagen = try? Data(contentsOf: urlImagen!)
                            portadaLibro.image = UIImage(data: dataImagen!)
                            //print (imagen)
                        }
                    }else{
                        portadaLibro.image = nil
                    }
                    //aux.portada = portadaLibro.image
                    portada = portadaLibro.image
                }
                
            }
            catch _ {
                
            }
        }else{ //Si no hay datos (fallo en la conexión a Internet)
            //Mostrar mensaje de error
            mostrarAlerta()
            
        }
        
    }
    
    //Esconder teclado cuando se pulsa fuera (no funciona con el scroll)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Acciones al pulsar buscar (Esconder teclado cuando se da a intro y buscar libro)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        //---->Consulta de la base de datos (si ya se ha busacado que no se vuelva a buscar)
        print ("----------Consulta de la base de datos---------")
        let libroEntidad = NSEntityDescription.entity(forEntityName: "Libro", in: self.contexto!)
        let peticion = libroEntidad?.managedObjectModel.fetchRequestFromTemplate(withName: "petLibro", substitutionVariables: ["isbn": textField.text!])
        do{
            let librosEntidad = try (self.contexto?.fetch(peticion!))! as! [Libro]
            if(librosEntidad.count > 0){ //Para evitar hacer búsquedas innecesarias
                print ("----------Para evitar hacer búsquedas innecesarias---------")
                textField.text = nil
                
                //Mostrar alerta 
                let alerta = UIAlertController(title: "Libro repetido", message: "El libro que busca ya está incluido en su lista", preferredStyle: .alert)
                let continueAccion = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alerta.addAction(continueAccion)
                self.present(alerta, animated: true, completion: nil)
                
                return true
            }
        }catch{
            
        }
        
        //Si llegamos a este punto es que es la primera vez que vamos a realizar la búsqueda
        print ("---------- primera vez que vamos a realizar la búsqueda---------")
        let texto = textField.text
        self.sincrono(texto: texto!)
        
        //---->Almacenamos la búsqueda en la base de datos (en caso de que sea la primera vez que se busca)
        print ("---------- Almacenamos la búsqueda en la base de datos---------")
        let nuevoLibroEntidad = NSEntityDescription.insertNewObject(forEntityName: "Libro", into: self.contexto!)
        nuevoLibroEntidad.setValue(isbnLibro, forKey: "isbn")
        nuevoLibroEntidad.setValue(nombre, forKey: "titulo")
        nuevoLibroEntidad.setValue(escritores, forKey: "autores")
        if portada != nil {
            nuevoLibroEntidad.setValue(UIImagePNGRepresentation(portada!), forKey: "portada")
        }
        do{
            try self.contexto?.save()
        }catch{
            
        }
        
        return true
        
    }
    
    func mostrarAlerta() {
        let alerta = UIAlertController(title: "Error de conexión", message: "Revise su conexión a Internet", preferredStyle: .alert)
        let continueAccion = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alerta.addAction(continueAccion)
        self.present(alerta, animated: true, completion: nil)
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        arrayLibros.append(aux)
        var libros: [datosLibro] = []
        libros = self.arrayLibros
        let sigVista = segue.destination as! TVC
        sigVista.coleccionLibros = libros

    }*/
    
}
