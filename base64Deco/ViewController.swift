//
//  ViewController.swift
//  base64Deco
//
//  Created by Enrique  on 23/08/16.
//  Copyright © 2016 Enrique . All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var tf_input: NSTextField!
    @IBOutlet weak var tf_output: NSTextField!
    
    @IBOutlet weak var btn_deco: NSButton!
    @IBOutlet weak var btn_pruebas: NSButton!
    
    
//    let fileManager : NSFileManager = NSFileManager.defaultManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tf_input.stringValue = "H4sIAAAAAAAAAF2QXW+CMBSG/0rD9RJbBETuKhQGGSUrumwuuyBQMxZZCR/LErP/vgOCGrng4nk/zuk5aV7WqZZV9VFmhdKc95Mmq5r3leZoK9PGxNIeRqIGElDhhhQ9MsEp99gepUwEYYICJqjwwFln7VB2Gy5k3SkoPOM1ttYXqG4g4mxP0SYRXjL09LK9SRGCr3BORa4L84OY8W2C9HF42V4jM5jtsfwtcwX0IPPPbHfsYlWcFWws8Gqhw7qIEIfYjqFPj+6rSB4kWCxTN3V8OcVERZLSFInkecfgv2Fie7/7ZCRL+27/SYDDwfoMuclGUA4HeEOuYF44FpVV3chWNRnNu/InA7sB9LuvZKNS2ZQynA0gvcIXEdOwMF7aw4kP+RhTfvmlhkkpWeomMe1R2hVlAdBf+/yFeJH/FEfa38ffPyJOHxQPAgAA"
//        decodificarB64(tf_input.stringValue)
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func stringToNSData(cadena:String) -> NSData {
        let stringsData = NSMutableData()
        if let stringData = cadena.dataUsingEncoding(NSUTF8StringEncoding)
        {
            stringsData.appendData(stringData)
            print("NSString to NSData success")
//            print(stringsData)
        } else
        {
            let cadenaError = "Error"
            let stringData = cadenaError.dataUsingEncoding(NSUTF8StringEncoding)
            NSLog("Uh oh, trouble with the String to NSData conversion !")
            stringsData.appendData(stringData!)
        }
        return stringsData
    }
    
    func decodificarB64(cadena: NSData) {
        
//        let data: NSData = NSData(base64EncodedString: cadena, options: NSDataBase64DecodingOptions(rawValue: 0))!
        
//        let data : NSData = NSData(base64EncodedData: cadena, options: NSDataBase64DecodingOptions(rawValue: 0))!
        let dataDecoded : NSData = NSData(base64EncodedData: cadena, options: NSDataBase64DecodingOptions(rawValue: 0))!
//        let data2 = NSData(base64EncodedString: cadena, options: NSDataBase64DecodingOptions(rawValue: 0))
        print("dataDecoded")
        print(dataDecoded)
        print(String(dataDecoded).characters.count)
        
        let dataDecompressed = dataDecoded.gzipDecompress
        print("Decoded and Decompressed")
        print(dataDecompressed)
        
        do {
            let anyObj = try NSJSONSerialization.JSONObjectWithData(dataDecompressed(), options: []) as! [String:AnyObject]
            // use anyObj here
            print("JSON result")
            print(anyObj)
            tf_output.stringValue = String(anyObj)
        } catch {
            print("json error: \(error)")
        }
        
//        let json : NSJSONSerialization = NSJSONSerialization.dataWithJSONObject(dataDecompressed(), options: nil)
        
//        tf_output.stringValue = String(dataDecompressed)
        
/*        do {
            let dataDecompressed : NSData = try dataDecoded.bbs_dataByInflating()
            print("Decoded and Decompressed")
            print(dataDecompressed)
            tf_output.stringValue = String(dataDecompressed)
        }
        catch
        {
            print(NSError)
        }
*/
    }
    
    @IBAction func btn_decodificar(sender: AnyObject) {

            if (tf_input.stringValue.characters.count != 0){
            let cadena = tf_input.stringValue.stringByReplacingOccurrencesOfString("\n", withString: "")
            print("cantidad en cadena")
            print(cadena.characters.count)
            if (cadena.characters.count%4 == 0)
            {
                let cadenaAsNSdata : NSData = stringToNSData(cadena)
                decodificarB64(cadenaAsNSdata)
            }else
            {
                let alert = NSAlert()
                alert.messageText = "Error"
                alert.informativeText = "La longitud de la cadena introducida debe ser dibisible entre 4 debido a que es codificada en Base64."
                alert.alertStyle = .WarningAlertStyle
                alert.addButtonWithTitle("OK")
                alert.beginSheetModalForWindow(self.view.window!,completionHandler: nil)
            }
        }
        else
        {
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText = "Debes introducir un elemento en el área para decodificar"
            alert.alertStyle = .WarningAlertStyle
            alert.addButtonWithTitle("OK")
            alert.beginSheetModalForWindow(self.view.window!,completionHandler: nil)
        }
    }
    
    @IBAction func pruebas(sender: AnyObject) {

        let pasteboard = NSPasteboard.generalPasteboard()
        pasteboard.clearContents()
        pasteboard.setString(tf_output.stringValue, forType: NSPasteboardTypeString)
    }

}