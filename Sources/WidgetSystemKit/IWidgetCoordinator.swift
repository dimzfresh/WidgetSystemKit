import Foundation
import SwiftUI
import Combine

public protocol IWidgetCoordinator<WidgetId, WidgetEvent>: ObservableObject {
    associatedtype WidgetId: Hashable
    associatedtype WidgetEvent: Hashable
    
    var widgets: [AnyWidget<WidgetId, WidgetEvent>] { get }
    
    func addWidget(_ widget: AnyWidget<WidgetId, WidgetEvent>)
    func removeWidget(_ widgetId: WidgetId)
    func showWidget(_ widgetId: WidgetId)
    func hideWidget(_ widgetId: WidgetId)
    func disableWidget(_ widgetId: WidgetId)
    func enableWidget(_ widgetId: WidgetId)
    func widgetState(_ widgetId: WidgetId) -> WidgetState
    func subscribeToWidgetEvents(_ subscriber: any IWidgetEventSubscriber<AnyWidget<WidgetId, WidgetEvent>>)
}

public final class WidgetCoordinator<WidgetId: Hashable, WidgetEvent: Hashable>: IWidgetCoordinator {
    @Published public private(set) var widgets: [AnyWidget<WidgetId, WidgetEvent>] = []
            
    public init() {}
    
    public func refreshWidgets(_ widgets: [AnyWidget<WidgetId, WidgetEvent>]) {
        self.widgets = widgets
    }
    
    public func addWidget(_ widget: AnyWidget<WidgetId, WidgetEvent>) {
        widgets.append(widget)
    }
    
    public func removeWidget(_ widgetId: WidgetId) {
        widgets.removeAll { $0.widgetId == widgetId }
    }
    
    public func showWidget(_ widgetId: WidgetId) {
        updateWidgetState(widgetId, state: .visible)
    }
    
    public func hideWidget(_ widgetId: WidgetId) {
        updateWidgetState(widgetId, state: .hidden)
    }
    
    public func disableWidget(_ widgetId: WidgetId) {
        updateWidgetState(widgetId, state: .disable)
    }
    
    public func enableWidget(_ widgetId: WidgetId) {
        updateWidgetState(widgetId, state: .visible)
    }
    
    public func widgetState(_ widgetId: WidgetId) -> WidgetState {
        widgets.first(where: { $0.widgetId == widgetId })?.widgetState ?? .visible
    }
    
    public func subscribeToWidgetEvents(_ subscriber: any IWidgetEventSubscriber<AnyWidget<WidgetId, WidgetEvent>>) {
        for widget in widgets {
            subscriber.subscribe(to: widget)
        }
    }
    
    private func updateWidgetState(_ widgetId: WidgetId, state: WidgetState) {
        guard let widget = widgets.first(where: { $0.widgetId == widgetId }) else { return }
        
        widget.updateWidgetState(state)
    }
}
