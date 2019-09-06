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
    let oriImage = UIImage(named: "2")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cOldImage.backgroundColor = nil
        cOldImage.contentMode = .scaleAspectFit
        cOldImage.image = oriImage
        //cOldImage.drawLayer(, color: <#T##UIColor#>)
        cOldImage.drawLayer(at: cOldImage.bounds)
        cOldImage.drawLayer(at: cOldImage.getAspectFitFrame(),color: UIColor.blue)
        var rect = CGRect(x: 0, y: 0, width: (oriImage?.size.width)! , height: (oriImage?.size.height)!)
        cOldImage.drawLayerOnOriginImage(at: rect, color: UIColor.green)
        rect = CGRect(x: 0, y: 0, width: (oriImage?.size.width)! / 2, height: (oriImage?.size.height)!)
        cOldImage.drawLayerOnOriginImage(at: rect, color: UIColor.orange)
        cNewImage.drawLayer(at: cNewImage.bounds)
        
        
        let img = oriImage?.scaleImage(image: oriImage!, newSize: CGSize(width: 500, height: 800))
        cNewImage.contentMode = .center
        cNewImage.image = img?.newImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }

    @IBAction func cOnClickedBtn(_ sender: UIButton) {
    }
    
}
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
    func getAspectFitRatio() -> CGFloat{
        if image == nil{
            return 0.0
        }
        let rect = getAspectFitFrame()
        let ratio = (self.image?.size.width)! / rect.width
        return ratio
    }
    func drawLayer(at rect: CGRect,color :UIColor = UIColor.red){
        let drawL = CALayer()
        drawL.borderWidth = 2
        drawL.borderColor = color.cgColor
        drawL.frame = rect
        self.layer.addSublayer(drawL)
    }
    func drawLayerOnOriginImage(at rect: CGRect,color :UIColor = UIColor.red){
        let newRect = AVMakeRect(aspectRatio: rect.size, insideRect: getAspectFitFrame())
        let imageRect = getAspectFitFrame()
        let ratio = getAspectFitRatio()
        let drawL = CALayer()
        drawL.borderWidth = 2
        drawL.borderColor = color.cgColor
        drawL.frame = CGRect(x: imageRect.minX + rect.minX * ratio, y: imageRect.minY + rect.minY * ratio, width: newRect.width, height: newRect.height)
        self.layer.addSublayer(drawL)
    }
}


extension UIImage {
    /**
     *  重设图片大小
     */
    
    func scaleImage(image:UIImage , newSize:CGSize)->(newImage: UIImage,newTargetSize: CGSize){
            //        获得原图像的尺寸属性
            let imageSize = image.size
            //        获得原图像的宽度数值
            let width = imageSize.width
            //        获得原图像的高度数值
            let height = imageSize.height
            
            let targetSize = AVMakeRect(aspectRatio: imageSize, insideRect: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            //        计算图像新尺寸与旧尺寸的宽高比例
           
//            let scaledWidth = width * scalerFactor let widthFactor = newSize.width/width
//            let heightFactor = newSize.height/height
//            //        获取最小的比例
//            let scalerFactor = (widthFactor < heightFactor) ? widthFactor : heightFactor
//
//            //        计算图像新的高度和宽度，并构成标准的CGSize对象
//            let scaledHeight = height * scalerFactor
//            let targetSize = CGSize(width: scaledWidth, height: scaledHeight)
//
            //        创建绘图上下文环境，
            UIGraphicsBeginImageContext(targetSize.size)
            image.draw(in: CGRect(x: 0, y: 0, width: targetSize.width , height: targetSize.height))
            //        获取上下文里的内容，将视图写入到新的图像对象
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            
            return (newImage!,targetSize.size)
            
    }
    
}

