//
//  VistaDetalle.swift
//  PeticionServidorJerarquico
//
//  Created by JESSICA MENDOZA RUIZ on 25/03/2017.
//  Copyright © 2017 JESSICA MENDOZA RUIZ. All rights reserved.
//

import UIKit

class VistaDetalle: UIViewController {
    
    var libro: datosLibro = datosLibro()

    @IBOutlet weak var isbn: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autores: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    var nombres: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isbn.text = "ISBN: \(libro.isbn)"
        self.titulo.text = "Título: \(libro.titulo)"
        for i in 0 ..< libro.autores.count{
            if(i == libro.autores.count-1){
                nombres = nombres + libro.autores[i]
            }else{
                nombres = nombres + libro.autores[i] + ", "
            }
        }
        self.autores.text = "Autor/es: \(nombres)"
        self.portada.image = libro.portada
        
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
