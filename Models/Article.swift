//
//  Copyright © 2020 Harsh patel. All rights reserved.
//

import UIKit

class Article: Codable, Identifiable {
    
    enum CodingKeys: CodingKey {
           case source, author, title, description, url, urlToImage, publishedAt, content
       }
       
       var id = UUID()
       let source: Source?
       let author: String?
       let title: String
       let description: String?
       let url: String?
       let urlToImage: String?
       let publishedAt: Date?
       let content: String?
       
       var wrappedAuthor: String {
           return author ?? "Unknown Author"
       }
       
       var wrappedUrlToImage: String {
           return urlToImage ?? ""
       }
       
       // MARK: Encoding/Decoding
       
       required init(from decoder: Decoder) throws {
           let container = try? decoder.container(keyedBy: CodingKeys.self)
           
           id = UUID()
           source = try (container?.decode(Source.self, forKey: .source) ?? Source(name: "Unknown Source"))
           author = try container?.decode(String?.self, forKey: .author)
           title = try (container?.decode(String.self, forKey: .title) ?? "Unknown Title")
           description = try container?.decode(String?.self, forKey: .description)
           url = try (container?.decode(String?.self, forKey: .url) ?? "")
           urlToImage = try container?.decode(String?.self, forKey: .urlToImage)
           publishedAt = try container?.decode(Date?.self, forKey: .publishedAt)
           content = try container?.decode(String?.self, forKey: .content)
       }
       
       func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           
           try container.encode(source, forKey: .source)
           try container.encode(author, forKey: .author)
           try container.encode(title, forKey: .title)
           try container.encode(description, forKey: .description)
           try container.encode(url, forKey: .url)
           try container.encode(urlToImage, forKey: .urlToImage)
           try container.encode(publishedAt, forKey: .publishedAt)
           try container.encode(content, forKey: .content)
       }
       

}
