//
//  ViewController.swift
//  YAPP
//
//  Created by Taylor Ertrachter on 1/24/20.
//  Copyright © 2020 Stanivision Inc. All rights reserved.
//

import UIKit
import FeedKit
import Alamofire


class ViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var podcastName = "sleepycast"
        
        let destination = DownloadRequest.suggestedDownloadDestination()

        Alamofire.download("https://itunes.apple.com/search?term=" + podcastName + "&entity=podcast&callback=dataReceiver", to: destination).response { response in // method defaults to `.get`
            print(response.request)
            print(response.response)
            print(response.temporaryURL)
            print(response.destinationURL)
            print(response.error)
            
            let feedURL = URL(string: response.error)!
        }
        
        let parser = FeedParser(data: feedURL)
        
        // Parse asynchronously, not to block the UI.
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            // Do your thing, then back to the Main thread
            DispatchQueue.main.async {
                // ..and update the UI
            }
        }
        
        let result = parser.parse()
                
        switch result {
        case .success(let feed):
            
            // Grab the parsed feed directly as an optional rss, atom or json feed object
            feed.rssFeed
            
            // Or alternatively...
            /*switch feed {
            case .atom(feed):       // Atom Syndication Format Feed Model
            case .rss(feed):        // Really Simple Syndication Feed Model
            case .json(feed):       // JSON Feed Model
            }*/
            
        case .failure(let error):
            print(error)
        }
        
    }


}

