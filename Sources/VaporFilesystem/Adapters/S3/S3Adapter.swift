import Foundation
@_exported import S3


open class S3Adapter {
    
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
    
    public let bucket: String
    public let client: S3
    public let signer: S3Signer
    public let config: Config
    
    public init(bucket: String, config: Config) throws {
        self.bucket = bucket
        self.config = config
        
        let signerConfig = S3Signer.Config(
            accessKey: config.auth.accessKey,
            secretKey: config.auth.secretKey,
            region: config.region,
            securityToken: config.auth.securityToken
        )
        
        self.signer = try S3Signer(signerConfig)
        self.client = try S3(defaultBucket: bucket, signer: self.signer)
    }
    
}
