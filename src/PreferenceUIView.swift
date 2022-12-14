import SwiftUI

struct PreferenceUIView: View {
    @State private var useHeader: Bool = false
    @State private var trackpadRange: String = "0,0,1,1"
    @State private var screenRange: String = "0,0,1,1"
    @State private var emitMouseEvent: Bool = false
    
    var mainMenu: MainMenu

    var isValid: Bool {
        return Settings.Range.stringIsValid(string: trackpadRange,
                                            name: "Trackpad region") &&
               Settings.Range.stringIsValid(string: screenRange,
                                            name: "Screen region")
    }

    var body: some View {
        VStack (alignment: .leading) {
            Toggle("Use settings in header file (settings.h)", isOn: $useHeader)
                .toggleStyle(.checkbox)
            if (!useHeader) {
                Form {
                    TextField("Trackpad region:", text: $trackpadRange)
                    TextField("Screen region:", text: $screenRange)
                }
                Toggle("Emit mouse events", isOn: $emitMouseEvent)
                    .toggleStyle(.checkbox)
            }
        }
        Button (action: {
            if isValid && !useHeader {
                settings.trackpadRange = Settings.Range(from: trackpadRange)
                settings.screenRange = Settings.Range(from: screenRange)
            }
            settings.emitMouseEvent = emitMouseEvent
            settings.useHeader = useHeader

            if mainMenu.process != nil {
                mainMenu.stopProcess(nil)
                mainMenu.startProcess(nil)
            }
        }) {
            Text("Apply").padding()
        }
    }
}
