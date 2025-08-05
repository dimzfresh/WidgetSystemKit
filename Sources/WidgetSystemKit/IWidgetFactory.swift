import Foundation

public protocol IWidgetFactory {
    associatedtype WidgetId: Hashable
    associatedtype WidgetEvent: Hashable
    
    func buildWidgets() -> [AnyWidget<WidgetId, WidgetEvent>]
}
