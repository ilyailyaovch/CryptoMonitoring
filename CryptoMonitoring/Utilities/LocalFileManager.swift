import Foundation
import SwiftUI

class LocalFileManager {

    static let instance = LocalFileManager()

    private init(){}

    func saveImage(image: UIImage, imageName: String, folderName: String) {
        // Create folder
        self.createFolderIfNeeded(folderName: folderName)
        // Get path for image
        guard
            let data = image.pngData(),
            let url = getURLForImage(imgName: imageName, folderName: folderName)
        else { return }
        // Save image to path
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. \(error)")
        }
    }

    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLForImage(imgName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path)
        else { return nil }
        return UIImage(contentsOfFile: url.path)
    }

    private func createFolderIfNeeded(folderName: String) {
        guard
            let url = getURLForFolder(folderName: folderName)
        else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Error creating directory. \(error)")
            }
        }
    }

    private func getURLForFolder(folderName: String) -> URL? {
        guard
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return nil }
        return url.appendingPathComponent(folderName)
    }

    private func getURLForImage(imgName: String, folderName: String) -> URL? {
        guard
            let folderURL = getURLForFolder(folderName: folderName)
        else { return nil }
        return folderURL.appendingPathComponent(imgName + ".png")
    }

}
