import Foundation
import XCTest
import Vapor

extension XCTestCase {
    
    func createContainer() -> Container {
        return BasicContainer(
            config: Config.default(),
            environment: Environment.testing,
            services: Services.default(),
            on: EmbeddedEventLoop()
        )
    }
    
}
