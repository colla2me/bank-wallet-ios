import ObjectMapper

class BlockExplorerBitcoinProvider: IBitcoinForksProvider {
    let name = "BlockExplorer.com"

    func url(for hash: String) -> String { return "https://blockexplorer.com/tx/" + hash }
    func apiUrl(for hash: String) -> String { return "https://blockexplorer.com/api/tx/" + hash }

    func convert(json: [String: Any]) -> IBitcoinResponse? {
        return try? BlockExplorerBitcoinResponse(JSONObject: json)
    }

}

class BlockExplorerBitcoinCashProvider: IBitcoinForksProvider {
    let name = "BlockExplorer.com"

    func url(for hash: String) -> String { return "https://bitcoincash.blockexplorer.com/tx/" + hash }
    func apiUrl(for hash: String) -> String { return "https://bitcoincash.blockexplorer.com/api/tx/" + hash }

    func convert(json: [String: Any]) -> IBitcoinResponse? {
        return try? BlockExplorerBitcoinResponse(JSONObject: json)
    }

}
class BlockExplorerBitcoinResponse: IBitcoinResponse, ImmutableMappable {
    var txId: String?
    var blockTime: Int?
    var blockHeight: Int?
    var confirmations: Int?

    var size: Int?
    var fee: Double?
    var feePerByte: Double?

    var inputs = [(value: Double, address: String?)]()
    var outputs = [(value: Double, address: String?)]()

    required init(map: Map) throws {
        txId = try? map.value("txid")
        blockTime = try? map.value("blocktime")
        blockHeight = try? map.value("blockheight")
        confirmations = try? map.value("confirmations")

        size = try? map.value("size")
        fee = try? map.value("fees")

        if let fee = fee, let size = size {
            feePerByte = fee * btcRate / Double(size)
        }

        if let vInputs: [[String: Any]] = try? map.value("vin") {
            vInputs.forEach { input in
                if let value = input["value"] as? Double {
                    let address = input["addr"] as? String

                    inputs.append((value: value, address: address))
                }

            }
        }
        if let vOutputs: [[String: Any]] = try? map.value("vout") {
            vOutputs.forEach { output in
                if let value = output["value"] as? String, let doubleValue = Double(value), let txScriptPubKey = output["scriptPubKey"] as? [String: Any] {
                    let address = (txScriptPubKey["addresses"] as? [String])?.first

                    outputs.append((value: doubleValue, address: address))
                }

            }
        }
    }

}
