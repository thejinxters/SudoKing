import Cocoa

class PasswordPromptController: NSViewController {

    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    @IBAction func pushUnlockButton(_ sender: Any) {
        passwordValidation(password: passwordTextField.stringValue)
    }
    
    @IBAction func submitTextField(_ sender: Any) {
        passwordValidation(password: passwordTextField.stringValue)
    }
    
    func passwordValidation(password: String) {
        // TODO: Validate not an empty string
        // TODO: Validate password against OP
        self.viewHasPassword(validPassword: true)
    }
    
    override func viewWillAppear() {
        // called immediately before view appears
        // TODO: Check for valid session to OP
        self.viewHasPassword(validPassword: false)
    }
    
    func viewHasPassword(validPassword: Bool){
        let windowController: MainWindowController = self.view.window?.windowController as! MainWindowController
        windowController.loadPasswordListView(validPassword: validPassword)
    }
    
}
