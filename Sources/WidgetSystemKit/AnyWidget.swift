import Foundation
import SwiftUI
import Combine

public class AnyWidget<WidgetId: Hashable, WidgetEvent: Hashable>: IWidgetViewModel {
    public let widgetId: WidgetId
    @Published public private(set) var widgetState: WidgetState
    
    public var widgetEventPublisher: AnyPublisher<WidgetEvent, Never> {
        widgetEventSubject.eraseToAnyPublisher()
    }
    
    private let widgetEventSubject = PassthroughSubject<WidgetEvent, Never>()
    
    public init(
        widgetId: WidgetId,
        widgetState: WidgetState
    ) {
        self.widgetId = widgetId
        self.widgetState = widgetState
    }
    
    public func updateWidgetState(_ widgetState: WidgetState) {
        self.widgetState = widgetState
    }
    
    public func sendWidgetEvent(_ event: WidgetEvent) {
        widgetEventSubject.send(event)
    }
    
    open func view() -> AnyView {
        fatalError("Subclasses must override view()")
    }
} 
