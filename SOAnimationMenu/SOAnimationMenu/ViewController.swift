
import UIKit

class ViewController: UIViewController, SOAnimatorMenuDelegate {

    var sharingView = SOAnimatorMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sharingView = SOAnimatorMenu(frame: CGRectMake(self.view!.center.x - 25, 100, 50, 50))
        sharingView.delegate = self
        sharingView.mainView.backgroundColor = UIColor.whiteColor()
        sharingView.addShareOptions(nil, withName: "fb")
        sharingView.addShareOptions(nil, withName: "twitter")
        sharingView.addShareOptions(nil, withName: "instagram")
        self.view!.addSubview(sharingView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openMenu(sender: AnyObject) {
        sharingView.open()
    }

    @IBAction func closeMenu(sender: AnyObject) {
        sharingView.close()
    }
    
    func animatorMenu(animatorMenu: SOAnimatorMenu, didSelectSharingOption name: String) {
        if name == "fb" {
            self.showAlert(self, messsage: "This is Facebook sharing")
        }
        else if name == "twitter" {
            self.showAlert(self, messsage: "This is Twitter sharing")
        }
        else if name == "instagram" {
            self.showAlert(self, messsage: "This is Instagram sharing")
        }

    }
    
    func showAlert(viewController : UIViewController , messsage : String)
    {
        let alert = UIAlertController(title: "SHARE", message: messsage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (alert: UIAlertAction!) -> Void in
        }
        alert.addAction(okAction)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }

}

