import Cocoa

class PasswordListController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    
    let passwords: [PasswordListItem] = OnePasswordLibrary.retrievePasswordList()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        selectFirstRow()
        
        // Registers keyDown listener within view
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
    }
    
    override func keyDown(with event: NSEvent){
        switch event.keyCode {
        case 36: // Return
            if (tableView.numberOfRows > 0){
                let uuid = passwords[tableView.selectedRow].uuid
                print(OnePasswordLibrary.retrievePassword(uuid: uuid) ?? "")
                self.view.window?.close()
            }
            break
        default:
            break
        }
    }
    
    func selectFirstRow() {
        if (tableView.numberOfRows > 0){
            tableView.selectRowIndexes(.init(integer: 0), byExtendingSelection: false)
        }
    }
}

extension PasswordListController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return passwords.count
    }
}

extension PasswordListController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "PasswordCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
//        var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        let item = passwords[row].name
        
        if tableColumn == tableView.tableColumns[0] {
            text = item
            cellIdentifier = CellIdentifiers.NameCell
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
//            cell.imageView?.image = image ?? nil
            return cell
        }
        return nil
    }
    
}
