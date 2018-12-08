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
        Log.debug("Valdiating Password")
        let isValidPassword = PasswordLibraryFactory.shared.validateMasterPassword(password: password)
        self.viewHasPassword(validPassword: isValidPassword)
    }
    
    override func viewWillAppear() {
        // called immediately before view appears
        let sessionActive = PasswordLibraryFactory.shared.validSessionActive()
        self.viewHasPassword(validPassword: sessionActive)
    }
    
    func viewHasPassword(validPassword: Bool){
        let windowController: MainWindowController = self.view.window?.windowController as! MainWindowController
        windowController.loadPasswordListView(validPassword: validPassword)
    }
    
}
