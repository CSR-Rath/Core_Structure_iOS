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

class FileDownloaderManager {
    
    static let shared = FileDownloaderManager()

    func shareFile(data: Data, doc_name: String) {
        DispatchQueue.main.async{
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


extension UITableView {

// Export pdf from UITableView and save pdf in drectory and return pdf file path
func exportAsPdfFromTable() -> String {

    self.showsVerticalScrollIndicator = false
    let originalBounds = self.bounds
    self.bounds = CGRect(x: originalBounds.origin.x,
                         y: originalBounds.origin.y,
                         width: self.contentSize.width,
                         height: self.contentSize.height)
    let pdfPageFrame = CGRect(x: 0, y: 0,
                              width: self.bounds.size.width,
                              height: self.contentSize.height)

    let pdfData = NSMutableData()
    UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
    UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
    guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
    self.layer.render(in: pdfContext)
    UIGraphicsEndPDFContext()
    self.bounds = originalBounds
    // Save pdf data
    return self.saveTablePdf(data: pdfData)

}

// Save pdf file in document directory
func saveTablePdf(data: NSMutableData) -> String {

    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docDirectoryPath = paths[0]
    let pdfPath = docDirectoryPath.appendingPathComponent("myPDF.pdf")
    if data.write(to: pdfPath, atomically: true) {
        return pdfPath.path
    } else {
        return "nil"
    }
}
}

