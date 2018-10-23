import Foundation
import S3

extension S3Adapter {
    
    public struct Auth {
        
        /// AWS Access Key
        let accessKey: String
        
        /// AWS Secret Key
        let secretKey: String
        
        /// AWS Security Token. Used to validate temporary credentials, such as those from an EC2 Instance's IAM role
        let securityToken : String?
        
        public init(accessKey: String, secretKey: String, securityToken : String? = nil) {
            self.accessKey = accessKey
            self.secretKey = secretKey
            self.securityToken = securityToken
        }
        
    }
    
}
