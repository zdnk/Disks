import Foundation
import S3

extension S3Adapter {
    
    public struct Config {
        
        let auth: Auth
        
        /// The region where S3 bucket is located.
        public let region: Region
        
        public let defaultAccess: AccessControlList
        
        public init(auth: Auth, region: Region, defaultAccess: AccessControlList = .privateAccess) {
            self.auth = auth
            self.region = region
            self.defaultAccess = defaultAccess
        }
        
    }
    
}
