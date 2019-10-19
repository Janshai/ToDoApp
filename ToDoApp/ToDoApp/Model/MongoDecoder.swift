//
//  MongoDecoder.swift
//  ToDoApp
//
//  Created by Jack Adams on 30/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation

class MongoDecoder {
    class func createDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom() { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = df.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Couldn't convert date")
            }
        }
        return decoder
    }
}
