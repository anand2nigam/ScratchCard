//
//  ScratchImageView.swift
//  ScratchCard
//
//  Created by Anand Nigam on 22/07/21.
//

import UIKit

class ScratchImageView: UIImageView {
    
    private var lastTouchPoint: CGPoint?
    
    var lineType: CGLineCap = .round
    var lineWidth: CGFloat = 30.0
    
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
}
