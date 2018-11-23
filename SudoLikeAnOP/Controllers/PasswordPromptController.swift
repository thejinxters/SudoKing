import Cocoa

class PasswordPromptController: NSViewController {

    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBAction func pushUnlockBtn(_ sender: Any) {
        self.viewHasPassword(validPassword: true)
    }
    
    override func viewWillAppear() {
        self.viewHasPassword(validPassword: false)
    }
    
    func viewHasPassword(validPassword: Bool){
        let windowController: MainWindowController = self.view.window?.windowController as! MainWindowController
        windowController.loadPasswordListView(validPassword: validPassword)
    }
    
}
