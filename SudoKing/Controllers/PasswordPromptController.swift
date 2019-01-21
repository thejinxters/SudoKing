import Cocoa

class PasswordPromptController: NSViewController {

    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    @IBOutlet weak var errorMessageLabel: NSTextField!
    
    @IBOutlet weak var unlockFieldView: NSView!
    
    @IBOutlet weak var unlockButton: NSButton!
    
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
            Animations.shake(view: unlockFieldView, distance: 5, repeatCount: 2, duration: 0.08)
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
    
    override func viewDidLoad() {
        
        // Setup Gradient Background
        view.wantsLayer = true
        let gradient = CAGradientLayer()
        gradient.colors = [Colors.DarkTeal.cgColor, Colors.LightTeal.cgColor]
        gradient.frame = view.layer!.bounds;
        view.layer = gradient
        
        // Modify look and feel of textfield
        passwordTextField.focusRingType = NSFocusRingType.none
        passwordTextField.isBezeled = false
        passwordTextField.drawsBackground = false
        
        // Modify look and feel of button
        unlockButton.focusRingType = NSFocusRingType.none
        unlockButton.isBordered = false
        unlockButton.isTransparent = true
    }
    
    func loadSessionView(){
        let windowController: MainWindowController = self.view.window?.windowController as! MainWindowController
        windowController.attemptLoadPasswordListView()
    }
    
}
