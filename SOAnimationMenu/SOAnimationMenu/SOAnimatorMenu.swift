
import UIKit

@objc protocol SOAnimatorMenuDelegate {
    optional func animatorMenu(animatorMenu: SOAnimatorMenu, didSelectSharingOption name: String)
}

class SOAnimatorMenu: UIView {

    var buttonIDs = [NSObject : AnyObject]()
    var arrButtons = [AnyObject]()
    var flagIsOpen = false
    var mainView: UIView!
    var shareAngle: CGFloat = 0.0
    var distFromCenter: CGFloat = 0.0
    var distanceOfBtns: CGFloat = 0.0
    var animationTime = NSTimeInterval()
    var animationDuration: NSTimeInterval = 0.0

    var delegate: SOAnimatorMenuDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.arrButtons = [AnyObject]()
        self.buttonIDs = [NSObject : AnyObject]()
        self.flagIsOpen = false
        self.mainView = self.createShareButton()
        self.mainView.frame = self.bounds
        self.shareAngle = -75
        self.distanceOfBtns = 70
        self.distFromCenter = 61
        self.animationTime = 0.15
        self.animationDuration = 0.4
        self.addSubview(self.mainView)
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.shareButtonClicked))
        self.mainView.addGestureRecognizer(tapGesture)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func shareButtonClicked(sender: UITapGestureRecognizer) {
        if self.flagIsOpen {
            self.close()
        }
        else {
            self.open()
        }
    }
    
    func close() {
        if self.flagIsOpen == true {
            var counter = 0.0
            for tmpViews in self.arrButtons {
                let subView: UIView = tmpViews as! UIView
                UIView.animateWithDuration(self.animationDuration, delay: self.animationTime * counter, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .AllowUserInteraction, animations: {() -> Void in
                    subView.transform = CGAffineTransformIdentity
                    subView.alpha = 0
                    }, completion: {(finished: Bool) -> Void in
                })
                counter += 1
            }
            self.flagIsOpen = false
        }
    }
    
    func open() {
        
        if self.flagIsOpen == false {
            var counter = 0.0
            for tmpViews in self.arrButtons {
                let subView: UIView = tmpViews as! UIView
                subView.alpha = 0
                UIView.animateWithDuration(self.animationDuration, delay: self.animationTime * counter, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .AllowUserInteraction, animations: {() -> Void in
                    subView.alpha = 1
                    subView.transform = self.getButtons(counter)
                    }, completion: {(finished: Bool) -> Void in
                })
                counter += 1
            }
            self.flagIsOpen = true
        }
        
    }
    
    func getButtons(indexTmp: Double) -> CGAffineTransform {
        let index = CGFloat(indexTmp)
        let tmpAngle: CGFloat = self.shareAngle + (self.distanceOfBtns * index)
        let deltaY: CGFloat = -self.distFromCenter * cos(tmpAngle / 180.0 * CGFloat(M_PI))
        let deltaX: CGFloat = self.distFromCenter * sin(tmpAngle / 180.0 * CGFloat(M_PI))
        return CGAffineTransformMakeTranslation(deltaX, deltaY)
    }
    
    func createShareButton() -> UIView? {
        let view = UIView(frame: self.frame)
        view.layer.cornerRadius = self.frame.size.width / 2
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        view.clipsToBounds = true
        
        let imageName = "share.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 12, y: 12, width: 26, height: 26)
        view.addSubview(imageView)
        
        return view
    }
    
    func addShareOptions(tmpView: UIView?, withName id: String) {
        var button = tmpView
        if button == nil {
            button = self.createButtonWithId(id)
        }
        self.arrButtons.append(button!)
        self.buttonIDs[id] = button
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.buttonClicked))
        button!.addGestureRecognizer(tapGesture)
        button!.alpha = 0
        button!.userInteractionEnabled = true
        self.addSubview(button!)
        self.sendSubviewToBack(button!)
        button!.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height / 2)
    }
    
    func buttonClicked(sender: UITapGestureRecognizer) {
        let view = sender.view
        let key = (self.buttonIDs as NSDictionary).allKeysForObject(view!)[0]
        self.delegate.animatorMenu?(self, didSelectSharingOption: key as! String)
    }
    
    func createButtonWithId(id: String) -> UIView? {
        let view = UIView()
        view.frame = CGRectMake(0, 0, self.frame.size.width / 1.5, self.frame.size.height / 1.5)
        view.layer.cornerRadius = view.frame.size.width / 2

        view.backgroundColor = UIColor.whiteColor()
        view.clipsToBounds = true

        var imageName = ""
        if id == "fb" {
            imageName = "facebook.png"
        }
        else if id == "twitter" {
            imageName = "twitter.png"
        }
        else if id == "instagram" {
            imageName = "insta.png"
        }
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(imageView)

        return view
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if CGRectContainsPoint(self.bounds, point) {
            return true
        }
        for subView in self.arrButtons {
            if CGRectContainsPoint(subView.frame, point) {
                return true
            }
        }
        return false
    }
}
