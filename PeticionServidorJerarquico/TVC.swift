//
//  TVC.swift
//  PeticionServidorJerarquico
//
//  Created by JESSICA MENDOZA RUIZ on 25/03/2017.
//  Copyright © 2017 JESSICA MENDOZA RUIZ. All rights reserved.
//

import UIKit

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
    
    var coleccionLibros: [datosLibro] = []
    var aux: datosLibro = datosLibro()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightAddBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TVC.addTapped))
        
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true)
        
        print("Array\(coleccionLibros)")
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
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
        return (self.coleccionLibros.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        cell.textLabel?.text = coleccionLibros[indexPath.row].titulo
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show1" {
            var libros: [datosLibro] = []
            libros = self.coleccionLibros
            let sigVista = segue.destination as! ViewController
            sigVista.arrayLibros = libros
            
        }else if segue.identifier == "show2" {
            let cc = segue.destination as! VistaDetalle
            let ip = self.tableView.indexPathForSelectedRow
            cc.libro = self.coleccionLibros[ip!.row]
        }
        
    }
    
}
