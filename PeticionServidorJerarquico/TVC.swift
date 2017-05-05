//
//  TVC.swift
//  PeticionServidorJerarquico
//
//  Created by JESSICA MENDOZA RUIZ on 25/03/2017.
//  Copyright © 2017 JESSICA MENDOZA RUIZ. All rights reserved.
//

import UIKit
import CoreData

struct datosLibro {
    var isbn: String
    var titulo: String
    var autores: [String]
    var portada: UIImage?
    init() {
        isbn = ""
        titulo = ""
        autores = []
        portada = nil
    }
}

//var coleccionLibros: [datosLibro] = []

class TVC: UITableViewController {
    
    /*var coleccionLibros: [datosLibro] = []
    var aux: datosLibro = datosLibro()*/
    var contexto: NSManagedObjectContext? = nil
    
    var titulos = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Inicializa contexto
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        contexto = appDelegate.persistentContainer.viewContext

        let rightAddBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TVC.addTapped))
        
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true)
        
        //print("Array\(coleccionLibros)")
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //---->Cargamos los títulos de los libros anteriormente buscados al abrir la app
        let libroEntidad = NSEntityDescription.entity(forEntityName: "Libro", in: self.contexto!)
        let peticion = libroEntidad?.managedObjectModel.fetchRequestTemplate(forName: "petLibros")
        do{
            let librosEntidad = try (self.contexto?.fetch(peticion!))! as! [Libro]
            for libroEntidad2 in librosEntidad{
                let titulo = libroEntidad2.value(forKey: "titulo") as! String
                self.titulos.append(titulo)
            }
        }catch{
            
        }

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func addTapped(sender:UIButton) {
        print("add pressed")
        
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "show1", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return (self.coleccionLibros.count)
        return (self.titulos.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        //cell.textLabel?.text = coleccionLibros[indexPath.row].titulo
        cell.textLabel?.text = titulos[indexPath.row]
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if segue.identifier == "show1" {
            var libros: [datosLibro] = []
            libros = self.coleccionLibros
            let sigVista = segue.destination as! ViewController
            sigVista.arrayLibros = libros
            
        }else*/ if segue.identifier == "show2" {
            let cc = segue.destination as! VistaDetalle
            let ip = self.tableView.indexPathForSelectedRow
            cc.libro = self.titulos[ip!.row]
        }
        
    }
    
}
