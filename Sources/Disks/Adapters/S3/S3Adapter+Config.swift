import Foundation
import S3

extension S3Adapter {
    
    public struct Config {
        
        
        let auth: Auth
        
        public let bucket: String
        
        /// The region where S3 bucket is located.
        public let region: Region
        
        public let defaultAccess: AccessControlList
        
        public init(bucket: String, region: Region, auth: Auth, defaultAccess: AccessControlList = .privateAccess) {
            self.bucket = bucket
            self.auth = auth
            self.region = region
            self.defaultAccess = defaultAccess
        }
        
    }
    
}
