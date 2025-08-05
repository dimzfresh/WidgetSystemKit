import Foundation
import SwiftUI
import Combine

public protocol IWidgetEventSubscriber<Widget> {
    associatedtype Widget: IWidgetViewModel

    func subscribe(to widget: Widget)
}
