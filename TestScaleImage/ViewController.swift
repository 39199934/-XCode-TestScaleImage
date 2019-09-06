//
//  ViewController.swift
//  TestScaleImage
//
//  Created by 罗万能 on 2019/9/6.
//  Copyright © 2019年 罗万能. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var cNewImage: UIImageView!
    @IBOutlet weak var cOldImage: UIImageView!
    let oriImage = UIImage(named: "2") ?? UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cOldImage.backgroundColor = nil
        cOldImage.contentMode = .scaleAspectFit
        cOldImage.image = oriImage
        
        cNewImage.contentMode = .center
        let img = oriImage.scaleImage(image: oriImage, newSize: CGSize(width: 600,height: 400))
        cNewImage.image = img.newImage
        
        cOldImage.drawLayerByOriginImageRect(at: CGRect(x: 0, y: 0, width: oriImage.size.width, height: oriImage.size.height),color:  UIColor.red)
        cNewImage.drawLayerByOriginImageRect(at: CGRect(x: 0, y: 0, width: cNewImage.image!.size.width, height: cNewImage.image!.size.height),color:  UIColor.red)
        
        
        let scaleRect = CGRect(x: 10, y: 10, width: 100, height: 50)
        cNewImage.drawLayerByOriginImageRect(at: scaleRect)
        let oriRect = cNewImage.image!.transletFromSelfRectToOriginRect(byOriginSize: oriImage.size, fromRect: scaleRect)
        cOldImage.drawLayerByOriginImageRect(at: oriRect)
        
        
        let sr2 = CGRect(x: 50, y: 100, width: 200, height: 300)
        cNewImage.drawLayerByOriginImageRect(at: sr2,color: UIColor.yellow)
        let or2 = cNewImage.image!.transletFromSelfRectToOriginRect(byOriginSize: oriImage.size, fromRect: sr2)
        cOldImage.drawLayerByOriginImageRect(at: or2,color: UIColor.yellow)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }

    @IBAction func cOnClickedBtn(_ sender: UIButton) {
    }
    
}


/*
 1、压缩图片   IMAGE
 2、获得压缩图片的新SIZE IMAGE
 3、取得压缩图片的定位RECT
 4、定位RECT转换为原RECT  IMAGE   参数需要，定位RECT ，原图大小
 5、原定位RECT画入UIIMAGEVIEW
 5.1 获得view内RECT
 5.2
 
 
 
 
 
 
 
 */
extension UIImageView{
    func getAspectFitFrame() -> CGRect{
        if self.image == nil{
            return CGRect(x: 0, y: 0, width: 0, height: 0)
        }
//        let bigFrame = self.bounds
//        let imageSize = self.image?.size
//        let widthF = (imageSize?.width)!/bigFrame.width
//        let heigthF = (imageSize?.height)! / bigFrame.height
//        let factor = widthF <= heigthF ? heigthF : widthF
//        let newImageSize = CGSize(width: (imageSize?.width)! / factor, height: (imageSize?.height)! / factor)
//        let viewCenter = self.center
//        let rect = CGRect(x: self.center.x - (newImageSize.width / 2), y: self.center.y - (newImageSize.height/2), width: newImageSize.width, height: newImageSize.height)
//
        
        let newRect = AVMakeRect(aspectRatio: (self.image?.size)!, insideRect: self.bounds)
        return newRect
    }
    
    func getImageFrame() -> CGRect{
        if self.image == nil{
            return CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        var newRect = CGRect()
        switch self.contentMode{
            
        case .scaleToFill:
            break
        case .scaleAspectFit:
            newRect = AVMakeRect(aspectRatio: (self.image?.size)!, insideRect: self.bounds)
        case .scaleAspectFill:
            break
        case .redraw:
            break
        case .center:
           
            newRect = CGRect(x: self.bounds.midX - (self.image?.size.width)!/2, y: self.bounds.midY - (self.image?.size.height)!/2, width: (self.image?.size.width)!, height: (self.image?.size.height)!)
            break
        case .top:
            break
        case .bottom:
            break
        case .left:
            break
        case .right:
            break
        case .topLeft:
            break
        case .topRight:
            break
        case .bottomLeft:
            break
        case .bottomRight:
            break
        }
        
        //let newRect = AVMakeRect(aspectRatio: (self.image?.size)!, insideRect: self.bounds)
        return newRect
    }
    func getAspectFitRatio() -> CGFloat{
        if image == nil{
            return 0.0
        }
        let rect = getAspectFitFrame()
        let ratio = (self.image?.size.width)! / rect.width
        return ratio
    }
    func getImageRatio() -> CGFloat{
        if image == nil{
            return 0.0
        }
        switch contentMode {
        case .scaleAspectFit:
            let rect = getImageFrame()
            let ratio = (self.image?.size.width)! / rect.width
            return ratio
        case .center:
            let rect = getImageFrame()
            let ratio = (self.image?.size.width)! / rect.width
            return ratio
        default:
            let rect = getAspectFitFrame()
            let ratio = (self.image?.size.width)! / rect.width
            return ratio
        }
        
    }
    func drawLayerOnImageView(at rect: CGRect,color :UIColor = UIColor.red){
        let drawL = CALayer()
        drawL.borderWidth = 5
        drawL.borderColor = color.cgColor
        drawL.frame = rect
        self.layer.addSublayer(drawL)
    }
    func drawLayerByOriginImageRect(at originRect: CGRect,color :UIColor = UIColor.red){
        switch self.contentMode {
        case .scaleAspectFit:
            //let newRect = AVMakeRect(aspectRatio: rect.size, insideRect: getAspectFitFrame())
            let imageRect = getImageFrame()
            let imageRatio = getImageRatio()
            let drawRect = CGRect(x: imageRect.minX + originRect.minX, y: imageRect.minY + originRect.minY, width: originRect.width / imageRatio, height: originRect.height / imageRatio)
           drawLayerOnImageView(at: drawRect,color:  color)
        case .center:
            let imageRect = getImageFrame()
           
            let drawRect = CGRect(x: imageRect.minX + originRect.minX, y: imageRect.minY + originRect.minY, width: originRect.width ,height: originRect.height )
            drawLayerOnImageView(at: drawRect,color:  color)
        default:
            break
        }
        
    }
}


extension UIImage {
    /**
     *  重设图片大小
     */
    
    func scaleImage(image:UIImage , newSize:CGSize)->(newImage: UIImage,newTargetSize: CGSize){
            //        获得原图像的尺寸属性
            let imageSize = image.size
        
            let targetSize = AVMakeRect(aspectRatio: imageSize, insideRect: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            UIGraphicsBeginImageContext(targetSize.size)
            image.draw(in: CGRect(x: 0, y: 0, width: targetSize.width , height: targetSize.height))
            //        获取上下文里的内容，将视图写入到新的图像对象
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            
            return (newImage!,targetSize.size)
            
    }
    
    //转换座标系
    func transletFromSelfRectToOriginRect(byOriginSize originSize: CGSize,fromRect selfRect:CGRect) -> CGRect{
        let selfSize = self.size
        let widthF = selfSize.width / originSize.width
        let heightF = selfSize.height / originSize.height
        let originRect = CGRect(x: selfRect.minX / widthF, y: selfRect.minY / heightF, width: selfRect.width / widthF, height: selfRect.height / heightF)
//        let newRect = AVMakeRect(aspectRatio: otherRect.size, insideRect: <#T##CGRect#>)
        return originRect
    }
    
}

