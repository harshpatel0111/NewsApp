//
//  Copyright © 2020 Harsh patel. All rights reserved.
//

import UIKit

class Source: Codable {
    enum CodingKeys: CodingKey {
        case name
    }
    
    init(name: String?) {
        self.name = name
    }
    
    let name: String?
    
    // MARK: Encoding/Decoding
    
    required init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        
        name = try? container?.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(name, forKey: .name)
    }
}
