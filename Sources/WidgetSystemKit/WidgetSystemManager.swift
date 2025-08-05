import Foundation
import SwiftUI
import Combine

public protocol IWidgetFactory<WidgetId, WidgetEvent> {
    associatedtype WidgetId: Hashable
    associatedtype WidgetEvent: Hashable
    
    func buildWidgets() -> [AnyWidget<WidgetId, WidgetEvent>]
}

public protocol IWidgetSystemManager<WidgetId, WidgetEvent>: ObservableObject {
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

public final class WidgetSystemManager<WidgetId: Hashable, WidgetEvent: Hashable>: IWidgetSystemManager {
    @Published public private(set) var widgets: [AnyWidget<WidgetId, WidgetEvent>] = []
    @Published public private(set) var widgetStates: [WidgetId: WidgetState] = [:]
        
    public init() {}
    
    public func addWidget(_ widget: AnyWidget<WidgetId, WidgetEvent>) {
        widgets.append(widget)
        widgetStates[widget.widgetId] = widget.widgetState
    }
    
    public func removeWidget(_ widgetId: WidgetId) {
        widgets.removeAll { $0.widgetId == widgetId }
        widgetStates.removeValue(forKey: widgetId)
    }
    
    public func showWidget(_ widgetId: WidgetId) {
        widgetStates[widgetId] = .visible
        updateWidgetState(widgetId, state: .visible)
    }
    
    public func hideWidget(_ widgetId: WidgetId) {
        widgetStates[widgetId] = .hidden
        updateWidgetState(widgetId, state: .hidden)
    }
    
    public func disableWidget(_ widgetId: WidgetId) {
        widgetStates[widgetId] = .disable
        updateWidgetState(widgetId, state: .disable)
    }
    
    public func enableWidget(_ widgetId: WidgetId) {
        widgetStates[widgetId] = .visible
        updateWidgetState(widgetId, state: .visible)
    }
    
    public func widgetState(_ widgetId: WidgetId) -> WidgetState {
        widgetStates[widgetId] ?? .visible
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
