import AppKit
import Foundation

/// Polls the system pasteboard for changes and fires a callback with the new string.
@MainActor
final class ClipboardWatcher {
    private let pasteboard: NSPasteboard
    private let interval: TimeInterval
    private let onChange: @MainActor (String) -> Void
    private var lastChangeCount: Int
    private var timer: Timer?

    init(
        pasteboard: NSPasteboard = .general,
        interval: TimeInterval = 0.3,
        onChange: @escaping @MainActor (String) -> Void
    ) {
        self.pasteboard = pasteboard
        self.interval = interval
        self.onChange = onChange
        self.lastChangeCount = pasteboard.changeCount
    }

    func start() {
        timer?.invalidate()
        // Timer.scheduledTimer fires on the run loop it was scheduled on (main); assumeIsolated reflects that.
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.tick()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    /// Replaces the pasteboard's plain-text contents and absorbs the resulting changeCount so we don't reprocess our own write.
    func write(_ text: String) {
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        lastChangeCount = pasteboard.changeCount
    }

    private func tick() {
        let count = pasteboard.changeCount
        guard count != lastChangeCount else { return }
        lastChangeCount = count
        guard let text = pasteboard.string(forType: .string) else { return }
        onChange(text)
    }
}
