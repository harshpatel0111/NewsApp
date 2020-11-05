//
//  Copyright © 2020 Harsh patel. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController {

    @IBOutlet weak var myWebView: WKWebView!
    var urlFromSegue: URL?
    var navigationTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = navigationTitle ?? ""
        setUpURLRequest()
    }
    
    func setUpURLRequest() {
        if let url = urlFromSegue {
        let urlRequest:URLRequest = URLRequest(url: url)
            myWebView.load(urlRequest)
        }
    }
    
    
}

