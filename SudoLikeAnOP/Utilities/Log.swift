import Foundation
import os.log

class Log {
    
    class func info(message: StaticString) {
        log(message: message, logType: OSLogType.info)
    }
    
    class func debug(message: StaticString) {
        log(message: message, logType: OSLogType.debug)
    }
    
    class func error(message: StaticString) {
        log(message: message, logType: OSLogType.error)
    }
    
    private class func log(message: StaticString, logType: OSLogType) {
        os_log(message, type: logType)
    }
    
}
