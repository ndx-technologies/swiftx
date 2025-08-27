import Foundation

struct Base64Data: Codable {
    let data: Data

    init(_ data: Data) {
        self.data = data
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(data.base64EncodedString())
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let base64String = try container.decode(String.self)
        guard let data = Data(base64Encoded: base64String) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "cannot decode base64 string to Data")
        }
        self.data = data
    }
}
