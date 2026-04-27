# Unsaved Changes Feature - iOS (Swift/SwiftUI)

## Overview
This feature adds a confirmation dialog to sheets/modals that prompts users to save their changes before closing when unsaved changes are detected.

## Implementation

### 1. **UnsavedChangesModifier** (`Utilities/UnsavedChangesModifier.swift`)
A SwiftUI view modifier that tracks changes and shows an alert.

**Usage:**
```swift
struct MyFormSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var initialName = ""
    @State private var showingDismissAlert = false
    
    var hasChanges: Bool {
        name != initialName
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    if hasChanges {
                        showingDismissAlert = true
                    } else {
                        dismiss()
                    }
                }
            }
        }
        .unsavedChangesAlert(
            initialValue: initialName,
            currentValue: name,
            showingAlert: $showingDismissAlert,
            onSave: {
                // Save logic here
                saveData()
                dismiss()
            },
            onDiscard: {
                dismiss()
            }
        )
    }
}
```

### 2. **Updated Views**

The following views have been updated with unsaved changes detection:
- `NewProjectSheet.swift` - Project creation/editing
- `TaskDetailView.swift` - Task editing (if applicable)
- `MeetingsView.swift` - Meeting forms (if applicable)

## Alert Options

The confirmation alert provides 3 options:
1. **Cancel** - Returns to editing (dismisses alert only)
2. **Don't Save** - Discards changes and closes sheet (destructive action, red text)
3. **Save & Exit** - Saves changes and closes sheet (default action)

## Technical Details

### Change Detection
The modifier compares initial and current values using `Equatable`:
- Works with any `Equatable` type
- Can compare simple values or complex structs
- Automatically detects any modifications

### Custom Form States
For complex forms with multiple fields, create a struct:
```swift
struct ProjectFormData: Equatable {
    var name: String
    var description: String
    var startDate: Date
    var budget: Double?
}
```

## iOS-Specific Features
- Uses native SwiftUI `.alert()` modifier
- Integrates with `Environment(\.dismiss)`
- Supports iOS 15+ alert actions with roles
- Destructive button automatically styled in red

## Best Practices
1. Initialize state with `@State private var initialValue` on view appear
2. Check `hasChanges` before showing alert
3. Always call `dismiss()` after save or discard
4. Use descriptive button labels

## Future Enhancements
Consider adding:
- Custom alert messages per view
- Support for async save operations
- Dirty field tracking (which fields changed)
- Auto-save drafts
