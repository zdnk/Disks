import Foundation
@_exported import S3

public struct S3Adapter {
    
    public let client: S3
    public let signer: S3Signer
    public let config: Config
    
    public init(config: Config) throws {
        self.config = config
        
        let signerConfig = S3Signer.Config(
            accessKey: config.auth.accessKey,
            secretKey: config.auth.secretKey,
            region: config.region,
            securityToken: config.auth.securityToken
        )
        
        self.signer = try S3Signer(signerConfig)
        self.client = try S3(defaultBucket: config.bucket, signer: self.signer)
    }
    
}
