import SwiftUI
import AppKit

@main
struct SanitizerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        MenuBarExtra("Sanitizer", systemImage: "link") {
            MenuView()
        }
        .menuBarExtraStyle(.window)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Sanitizer").font(.headline)
            Text("Placeholder — no features yet.")
                .font(.caption)
                .foregroundStyle(.secondary)
            Divider()
            Button("Quit") { NSApp.terminate(nil) }
                .keyboardShortcut("q")
        }
        .padding(12)
        .frame(width: 240)
    }
}
