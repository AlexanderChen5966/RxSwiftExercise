//
//  TestViewController1.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2021/1/4.
//  Copyright © 2021 AlexanderChen. All rights reserved.
//

import UIKit
import LinkPresentation

@available(iOS 13.0, *)
class TestViewController1: UIViewController {
    
    @IBOutlet weak var richView: UIView!

    private lazy var linkView = LPLinkView()
    private var metaData: LPLinkMetadata = LPLinkMetadata() {
        didSet {
            DispatchQueue.main.async {
                self.addRichLinkToView(view: self.richView, metadata: self.metaData)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.apple.com/airpods-pro/")!
//        fetchURLPreview(url: url)
        
        //Open this code below to custom meta data
        let metadata = fetchPreviewManually(title: "[Custom Link] Apple AirPods Pro", originalURL: url, fileName: "airpods_pro", fileType: "jpg")
        self.metaData = metadata!

    }
    
    
    func addRichLinkToView(view: UIView, metadata: LPLinkMetadata) {
        linkView = LPLinkView(metadata: metadata)
        view.addSubview(linkView)
        linkView.frame =  view.bounds
    }

    //Custom metadata
    @available(iOS 13.0, *)
    func fetchPreviewManually(title: String, originalURL: URL, fileName: String, fileType: String) -> LPLinkMetadata? {
        let metaData = LPLinkMetadata()
        metaData.title  = title
        metaData.originalURL = originalURL
        let path = Bundle.main.path(forResource: fileName, ofType: fileType)
        metaData.imageProvider = NSItemProvider(contentsOf: URL(fileURLWithPath: path ?? ""))
    
        return metaData
    }
        
    @available(iOS 13.0, *)
    func fetchURLPreview(url: URL) {
        let metadataProvider = LPMetadataProvider()
        metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
            guard let data = metadata, error == nil else {
                return
            }
            self.metaData = data
        }
    }

}
