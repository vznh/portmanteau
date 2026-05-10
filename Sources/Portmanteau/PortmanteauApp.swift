import SwiftUI
import AppKit

@main
struct PortmanteauApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        MenuBarExtra("Portmanteau", systemImage: "link") {
            MenuView()
        }
        .menuBarExtraStyle(.window)
    }
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var watcher: ClipboardWatcher?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        let watcher = ClipboardWatcher { [weak self] text in
            self?.handle(text)
        }
        watcher.start()
        self.watcher = watcher
        print("[portmanteau] watching clipboard…")
    }

    private func handle(_ text: String) {
        let preview = text.count > 120 ? String(text.prefix(120)) + "…" : text
        print("[clipboard] \(preview)")
        let result = Sanitize.run(text)
        for change in result.changes {
            let removed = change.removed.joined(separator: ", ")
            print("[sanitize]  \(change.original.absoluteString)")
            print("        →   \(change.cleaned.absoluteString)  (-\(removed))")
        }
        if result.didChange {
            watcher?.write(result.cleaned)
        }
    }
}

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Portmanteau").font(.headline)
            Text("Watching clipboard. See terminal for logs.")
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
