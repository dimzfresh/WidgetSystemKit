import SwiftUI

public struct WidgetItemContainer<Content: View, Widget: IWidgetViewModel>: View {
    @ObservedObject private var widget: Widget
    private let content: (Widget) -> Content
    
    public init(
        widget: Widget,
        @ViewBuilder content: @escaping (Widget) -> Content
    ) {
        self.widget = widget
        self.content = content
    }
    
    public var body: some View {
        Group {
            switch widget.widgetState {
            case .visible:
                content(widget)
            case .hidden:
                EmptyView()
            case .disable:
                content(widget)
                    .disabled(true)
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.3), value: widget.widgetState)
    }
}
