import SwiftyBeaver

class Log {
    private init() {}
    
    private static let format = "$Dyyyy-MM-dd $DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"

    private static let console = ConsoleDestination()

    static let type = SwiftyBeaver.self

    static func setLogLevel(level: SwiftyBeaver.Level) {
        type.addDestination(console)
        console.format = format
        console.minLevel = level
    }
    
    static func setLogLevel(dartLevel: Int) {
        type.addDestination(console)
        console.format = format
        console.minLevel = convertLogLevel(dartLevel)
    }
    
    private static func convertLogLevel(_ dartLevel: Int) -> SwiftyBeaver.Level {
        switch dartLevel {
        case 2:
            return SwiftyBeaver.Level.verbose
        case 3:
            return SwiftyBeaver.Level.debug
        case 4:
            return SwiftyBeaver.Level.info
        case 5:
            return SwiftyBeaver.Level.warning
        case 6:
            return SwiftyBeaver.Level.error
        default:
            return SwiftyBeaver.Level.warning
        }
    }
}
