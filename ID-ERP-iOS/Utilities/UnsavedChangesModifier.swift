import SwiftUI

/// A view modifier that tracks unsaved changes and shows a confirmation dialog before dismissing
struct UnsavedChangesModifier<T: Equatable>: ViewModifier {
    let initialValue: T
    let currentValue: T
    @Binding var showingDismissAlert: Bool
    let onSave: () -> Void
    let onDiscard: () -> Void
    
    var hasUnsavedChanges: Bool {
        initialValue != currentValue
    }
    
    func body(content: Content) -> some View {
        content
            .alert("Unsaved Changes", isPresented: $showingDismissAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Don't Save", role: .destructive) {
                    onDiscard()
                }
                Button("Save & Exit") {
                    onSave()
                }
            } message: {
                Text("You have unsaved changes. Do you want to save before closing?")
            }
    }
}

extension View {
    /// Adds unsaved changes tracking to a view
    /// - Parameters:
    ///   - initialValue: The initial value to compare against
    ///   - currentValue: The current value
    ///   - showingAlert: Binding to control alert visibility
    ///   - onSave: Action to perform when user chooses to save
    ///   - onDiscard: Action to perform when user discards changes
    func unsavedChangesAlert<T: Equatable>(
        initialValue: T,
        currentValue: T,
        showingAlert: Binding<Bool>,
        onSave: @escaping () -> Void,
        onDiscard: @escaping () -> Void
    ) -> some View {
        self.modifier(UnsavedChangesModifier(
            initialValue: initialValue,
            currentValue: currentValue,
            showingDismissAlert: showingAlert,
            onSave: onSave,
            onDiscard: onDiscard
        ))
    }
}

/// Helper to check for unsaved changes in forms
struct FormState<T: Equatable>: Equatable {
    let value: T
    
    init(_ value: T) {
        self.value = value
    }
    
    static func == (lhs: FormState<T>, rhs: FormState<T>) -> Bool {
        lhs.value == rhs.value
    }
}
