import Foundation
import SwiftUI
import Combine

public protocol IWidgetViewModel: Identifiable, ObservableObject {
    associatedtype WidgetId: Hashable
    associatedtype WidgetEvent: Hashable

    var id: WidgetId { get }
    var widgetState: WidgetState { get }
    var widgetEventPublisher: AnyPublisher<WidgetEvent, Never> { get }
    
    func view() -> AnyView
    func updateWidgetState(_ widgetState: WidgetState)
    func sendWidgetEvent(_ event: WidgetEvent)
}
