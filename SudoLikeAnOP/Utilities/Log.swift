import Foundation
import os.log

class Log {
    
    class func info(_ message: String) {
        log(message: message, logType: OSLogType.info)
    }
    
    class func debug(_ message: String) {
        log(message: message, logType: OSLogType.debug)
    }
    
    class func error(_ message: String) {
        log(message: message, logType: OSLogType.error)
    }
    
    private class func log(message: String, logType: OSLogType) {
        let customLog = OSLog(subsystem: "com.sudolikeanop.cli", category: "sudolikeanop")
        os_log("%{public}@", log: customLog, type: logType, message)
    }
    
}
