//
//  ScratchImageView.swift
//  ScratchCard
//
//  Created by Anand Nigam on 22/07/21.
//

import UIKit

protocol ScratchCardDelegate {
    func scratchCardEraseProgress(is progress: Double)
}

class ScratchImageView: UIImageView {
    
    private var lastTouchPoint: CGPoint?
    
    var lineType: CGLineCap = .round
    var lineWidth: CGFloat = 30.0
    var delegate: ScratchCardDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        guard let touch = touches.first else {
            return
        }
 
        lastTouchPoint = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first, let point = lastTouchPoint, let image = image else { return }
        
        let currentLocation = touch.location(in: self)
        eraseBetween(fromPoint: point, currentPoint: currentLocation)
        lastTouchPoint = currentLocation
        
        if let _ = delegate {
            delegate?.scratchCardEraseProgress(is: alphaOnlyPercentageOf(image: image))
        }
    }
    
    func eraseBetween(fromPoint: CGPoint, currentPoint: CGPoint) {
    
        UIGraphicsBeginImageContext(self.frame.size)
        
        image?.draw(in: self.bounds)
        
        let path = CGMutablePath()
        path.move(to: fromPoint)
        path.addLine(to: currentPoint)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setShouldAntialias(true)
        context?.setLineCap(lineType)
        context?.setLineWidth(lineWidth)
        context?.setBlendMode(.clear)
        context?.addPath(path)
        context?.strokePath()
        
        image = UIGraphicsGetImageFromCurrentImageContext()
  
        UIGraphicsEndImageContext()
    }
    
    private func alphaOnlyPercentageOf(image: UIImage) -> Double {
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        
        let bitmapBytesPerRow = width
        let bitmapByteCount = bitmapBytesPerRow * height

        let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: bitmapByteCount)

        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.alphaOnly.rawValue).rawValue)!
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.clear(rect)
        context.draw(image.cgImage!, in: rect)
        
        var alphaOnlyPixels = 0
        
        for x in 0...Int(width) {
            for y in 0...Int(height) {
                
                if pixelData[y * width + x] == 0 {
                   alphaOnlyPixels += 1
                }
            }
        }
   
        free(pixelData)

        return Double(Float(alphaOnlyPixels) / Float(bitmapByteCount)) * 100
    }
}
