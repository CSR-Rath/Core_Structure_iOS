//
//  FileDownloader.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 11/3/25.
//

import UIKit

enum ExtensionsFile: String{
    case PDF = "pdf"
    case XLSX = "xlsx"
    case PNG = "PNG"
}

class FileDownloader {
    
    static let shared = FileDownloader()

    func shareFile(data: Data, doc_name: String) {

        DispatchQueue.main.async {
            
            let barButtonItemAppearance = UIBarButtonItem.appearance()
            let attributes:[NSAttributedString.Key : Any] = [ NSAttributedString.Key.foregroundColor: UIColor.orange]
            barButtonItemAppearance.setTitleTextAttributes(attributes, for: .normal)
            barButtonItemAppearance.setTitleTextAttributes(attributes, for: .highlighted)
            
            
            
            let temporaryFolder = FileManager.default.temporaryDirectory
            let temporaryFileURL = temporaryFolder.appendingPathComponent(doc_name)
            do {
                try data.write(to: temporaryFileURL)
                let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                let activityViewController = UIActivityViewController(activityItems: [temporaryFileURL], applicationActivities: nil)
          
                keyWindow?.rootViewController?.present(activityViewController,animated: true, completion: nil)

            } catch {
                print(error)
            }
        }
    }
}
