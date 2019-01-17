import Cocoa

class PasswordPromptController: NSViewController {

    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    @IBOutlet weak var errorMessageLabel: NSTextField!
    
    @IBAction func pushUnlockButton(_ sender: Any) {
        errorMessageLabel.stringValue = ""
        passwordValidation(password: passwordTextField.stringValue)
    }
    
    @IBAction func submitTextField(_ sender: Any) {
        errorMessageLabel.stringValue = ""
        passwordValidation(password: passwordTextField.stringValue)
    }
    
    func passwordValidation(password: String) {
        Log.debug("Valdiating Password")
        do {
            try PasswordLibraryFactory.shared.validateMasterPassword(password: password)
            self.loadSessionView()
        } catch let error as PasswordError {
            errorMessageLabel.stringValue = error.message
            Log.error("Returned error Message: \(error.message)")
        } catch {
            errorMessageLabel.stringValue = "Unable to Log In"
            Log.error("Error valdiating password: \(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear() {
        errorMessageLabel.stringValue = ""
        self.loadSessionView()
    }
    
    func loadSessionView(){
        let windowController: MainWindowController = self.view.window?.windowController as! MainWindowController
        windowController.attemptLoadPasswordListView()
    }
    
}
