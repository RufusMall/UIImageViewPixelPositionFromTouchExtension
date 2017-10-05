//
//  UIImageViewExtension.swift
//
//  Created by Rufus on 19/09/2017.
//  Copyright © 2017 Apple. All rights reserved.

import Foundation
import UIKit

public extension UIImageView
{
    private func isPointInView()->Bool
    {
        return true;
    }
    
    func pixelPoint(fromViewPoint touch: CGPoint) -> CGPoint {
        
        if self.image == nil {
        return CGPoint(x: 0, y: 0)
        }
        
        let image = self.image!
        
        // Sanity check to see whether the touch is actually in the view
        if touch.x >= 0.0 && touch.x <= frame.size.width && touch.y >= 0.0 && touch.y <= frame.size.height {
            // http://developer.apple.com/library/ios/#DOCUMENTATION/UIKit/Reference/UIView_Class/UIView/UIView.html#//apple_ref/occ/cl/UIView
            switch contentMode {
            // Simply scale the image size by the size of the frame
            case .scaleToFill,             // Redraw is basically the same as scale to fill but redraws itself in the drawRect call (so when bounds change)
            .redraw:
                return CGPoint(x: floor(touch.x / (frame.size.width / image.size.width)), y: floor(touch.y / (frame.size.height / image.size.height)))
            // Although the documentation doesn't state it, we will assume a centered image. This mode makes the image fit into the view with its aspect ratio
            case .scaleAspectFit:
                // If the aspect ratio favours width over height in relation to the images aspect ratio
                if frame.size.width / frame.size.height > image.size.width / image.size.height {
                    // Checking whether the touch coordinate is not in a 'blank' spot on the view
                    if touch.x >= (frame.size.width / 2.0) - (((frame.size.height / image.size.height) * image.size.width) / 2.0) && touch.x <= (frame.size.width / 2.0) + (((frame.size.height / image.size.height) * image.size.width) / 2.0) {
                        // Scaling by using the height ratio as a reference, and minusing the blank x coordiantes on the view
                        return CGPoint(x: floor((touch.x - (frame.size.width / 2.0) - (((frame.size.height / image.size.height) * image.size.width) / 2.0)) / (frame.size.height / image.size.height)), y: floor(touch.y / (frame.size.height / image.size.height)))
                    }
                }
                else if frame.size.width / frame.size.height < image.size.width / image.size.height {
                    // Obtaining half of the view that is taken up by the aspect ratio
                    let halfAspectFit: CGFloat = ((frame.size.width / image.size.width) * image.size.height) / 2.0
                    // Checking whether the touch coordinate is not in a 'blank' spot on the view
                    if touch.y >= (frame.size.height / 2.0) - halfAspectFit && touch.y <= (frame.size.height / 2.0) + halfAspectFit {
                        // Scaling by using the width ratio as a reference, and minusing the blank y coordinates on the view
                        return CGPoint(x: floor(touch.x / (frame.size.width / image.size.width)), y: floor((touch.y - ((frame.size.width / 2.0) - halfAspectFit)) / (frame.size.height / image.size.height)))
                    }
                }
                else {
                    return CGPoint(x: floor(touch.x / (frame.size.width / image.size.width)), y: floor(touch.y / (frame.size.width / image.size.height)))
                }
            // This fills the view with the image in its aspect ratio, meaning that it could get cut off in either axis
            case .scaleAspectFill:
                // If the aspect ratio favours width over height in relation to the images aspect ratio
                if frame.size.width / frame.size.height > image.size.width / image.size.height {
                    // Scaling by using the width ratio, this will cut off some height
                    return CGPoint(x: floor(touch.x / (frame.size.width / image.size.width)), y: floor(touch.y / (frame.size.width / image.size.width)))
                }
                else if frame.size.width / frame.size.height < image.size.width / image.size.height {
                    // Scaling by using the height ratio, this will cut off some width
                    return CGPoint(x: floor(touch.x / (frame.size.height / image.size.height)), y: floor(touch.y / (frame.size.height / image.size.height)))
                }
                else {
                    return CGPoint(x: floor(touch.x / (frame.size.width / image.size.width)), y: floor(touch.y / (frame.size.width / image.size.height)))
                }
            // This centers the image in the view both vertically and horizontally
            case .center:
                // Check whether our touch is on the image centered vertically and horizontally
                if touch.x >= (frame.size.width / 2.0) - (image.size.width / 2.0) && touch.x <= (frame.size.width / 2.0) + (image.size.width / 2.0) && touch.y >= (frame.size.height / 2.0) - (image.size.height / 2.0) && touch.y <= (frame.size.height / 2.0) + (image.size.height / 2.0) {
                    // Just return the touch coordinates and minus the offset
                    return CGPoint(x: floor(touch.x - (frame.size.width / 2.0) - (image.size.width / 2.0)), y: floor(touch.y - (frame.size.height / 2.0) - (image.size.height / 2.0)))
                }
            // This centers the image horizontally and moves it up to the top
            case .top:
                // Check whether our touch is on the image centered horizontally and put at the vertical start
                if touch.x >= (frame.size.width / 2.0) - (image.size.width / 2.0) && touch.x <= (frame.size.width / 2.0) + (image.size.width / 2.0) && touch.y <= image.size.height {
                    // Just return the touch coordinates and minus the offset
                    return CGPoint(x: floor(touch.x - (frame.size.width / 2.0) - (image.size.width / 2.0)), y: floor(touch.y))
                }
            // This centers the image horizontally and moves it down to the bottom
            case .bottom:
                // Check whether our touch is on the image centered horizontally and put at the vertical end
                if touch.x >= (frame.size.width / 2.0) - (image.size.width / 2.0) && touch.x <= (frame.size.width / 2.0) + (image.size.width / 2.0) && touch.y >= frame.size.height - image.size.height {
                    // Just return the touch coordinates and minus the offset
                    return CGPoint(x: floor(touch.x - (frame.size.width / 2.0) - (image.size.width / 2.0)), y: floor(touch.y - (frame.size.height - image.size.height)))
                }
            // This moves the image to the horizontal start and centers it vertically
            case .left:
                // Check whether our touch is on the image at the horizontal start and centered vertically
                if touch.x <= image.size.width && touch.y >= (frame.size.height / 2.0) - (image.size.height / 2.0) && touch.y <= (frame.size.height / 2.0) + (image.size.height / 2.0) {
                    return CGPoint(x: floor(touch.x), y: floor(touch.y - (frame.size.height / 2.0) - (image.size.height / 2.0)))
                }
            // This moves the image to the horizontal end and centers it vertically
            case .right:
                if touch.x >= frame.size.width - image.size.width && touch.y >= (frame.size.height / 2.0) - (image.size.height / 2.0) && touch.y <= (frame.size.height / 2.0) + (image.size.height / 2.0) {
                    return CGPoint(x: floor(touch.x - (frame.size.width - image.size.width)), y: floor(touch.y - (frame.size.height / 2.0) - (image.size.height / 2.0)))
                }
            // This simply moves the image to the horizontal and vertical start
            case .topLeft:
                if touch.x <= image.size.width && touch.x <= image.size.height {
                    // My favourite
                    return CGPoint(x: floor(touch.x), y: floor(touch.y))
                }
            // This moves the image to the horizontal end and vertical start
            case .topRight:
                if touch.x >= frame.size.width - image.size.width && touch.y <= image.size.height {
                    return CGPoint(x: floor(touch.x - (frame.size.width - image.size.width)), y: floor(touch.y))
                }
            // This moves the image to the horizontal start and vertical end
            case .bottomLeft:
                if touch.x <= image.size.width && touch.y <= frame.size.height - image.size.height {
                    return CGPoint(x: floor(touch.x), y: floor(touch.y - (frame.size.height - image.size.height)))
                }
            // This moves the image to the horizontal and vertical end
            case .bottomRight:
                if touch.x <= frame.size.width - image.size.width && touch.y <= frame.size.height - image.size.height {
                    return CGPoint(x: floor(touch.x - (frame.size.width - image.size.width)), y: floor(touch.y - (frame.size.height - image.size.height)))
                }
            }
        }
        return CGPoint(x: 0, y: 0 )
    }
}
