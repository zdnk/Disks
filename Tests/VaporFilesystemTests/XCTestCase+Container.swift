import Foundation
import XCTest
import Vapor

extension XCTestCase {
    
    func container() -> Container {
        return BasicContainer(
            config: Config.default(),
            environment: Environment.testing,
            services: Services.default(),
            on: EmbeddedEventLoop()
        )
    }
    
}
