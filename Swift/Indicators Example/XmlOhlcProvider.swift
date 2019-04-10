import Foundation

class XmlOhlcProvider {
    let xmlUrl : URL
    
    required init (xmlUrl: URL) {
        self.xmlUrl = xmlUrl
    }
    
    func getPoints() -> [OhlcPoint] {
        let xmlParser = XMLParser(contentsOf: xmlUrl)!
        let dataDelegate = XmlOhlcProviderDelegate()
        xmlParser.delegate = dataDelegate
        
        xmlParser.parse()
        return dataDelegate.points
    }
}


private class XmlOhlcProviderDelegate : NSObject, XMLParserDelegate {
    var points = [OhlcPoint]()
    var parcingElement: String = ""
    var deserializedOhlcPoint : OhlcPoint?
    
    override init() {
        points = [OhlcPoint]()
    }
    
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if (elementName == "StockPrice") {
            deserializedOhlcPoint = OhlcPoint()
        }
        parcingElement = elementName
    }
    
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "StockPrice") {
            points.append(deserializedOhlcPoint!)
            deserializedOhlcPoint = nil;
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if(parcingElement == "Date"){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            deserializedOhlcPoint!.date = dateFormatter.date(from: string)!;
        }
        if(parcingElement == "Open"){
            deserializedOhlcPoint!.open = Double(string)!;
        }
        if(parcingElement == "High"){
            deserializedOhlcPoint!.high = Double(string)!;
        }
        if(parcingElement == "Low"){
            deserializedOhlcPoint!.low = Double(string)!;
        }
        if(parcingElement == "Close"){
            deserializedOhlcPoint!.close = Double(string)!;
        }
        if(parcingElement == "Volume"){
            deserializedOhlcPoint!.volume = Double(string)!;
        }
        parcingElement = ""
    }
}
