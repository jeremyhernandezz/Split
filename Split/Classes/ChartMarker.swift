//
//  ChartMarker.swift
//  Split
//  Code based on the BallowsMaker code library 
//

import Foundation
import Charts

//Class created to add markers to the line Chart in the profile page. This code is based on the BallonsMaker code
class ChartMarker: MarkerView {
    var text = ""

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)
        
        //Decoded weights array to get print the weight and date of each weight entry in the LineChart graph
        do {
            if UserDefaults.standard.object(forKey: "Weights") != nil {
                if let decodedWeights = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData((UserDefaults.standard.object(forKey: "Weights") as! Data)) as? [Weight] {
                    
                    text = "Date: " + String(decodedWeights[Int(entry.x)].date!) + "\n Weight: " + String(entry.y)
                }
            }

        } catch {
            print("Couldn't decode data.")
        }
        
    }

    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)

        var drawAttributes = [NSAttributedString.Key : Any]()
        drawAttributes[.font] = UIFont.systemFont(ofSize: 15)
        drawAttributes[.foregroundColor] = UIColor.white
        drawAttributes[.backgroundColor] = UIColor.darkGray

        self.bounds.size = (" \(text) " as NSString).size(withAttributes: drawAttributes)
        self.offset = CGPoint(x: 0, y: -self.bounds.size.height - 2)

        let offset = self.offsetForDrawing(atPoint: point)

        drawText(text: " \(text) " as NSString, rect: CGRect(origin: CGPoint(x: point.x + offset.x, y: point.y + offset.y), size: self.bounds.size), withAttributes: drawAttributes)
    }

    func drawText(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: rect.origin.x + (rect.size.width - size.width) / 2.0, y: rect.origin.y + (rect.size.height - size.height) / 2.0, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
}
