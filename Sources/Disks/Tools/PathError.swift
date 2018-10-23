import Foundation

public enum PathError: Swift.Error {
    case invalid(String)
    case outsideOfRoot(String)
    case rootViolation
}
