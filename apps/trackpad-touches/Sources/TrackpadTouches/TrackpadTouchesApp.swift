import AppKit
import SwiftUI

@main
struct TrackpadTouchesApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup("Trackpad Touches") {
            TouchCanvas()
                .frame(minWidth: 520, minHeight: 420)
        }
        .windowResizability(.contentMinSize)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
}

struct TouchCanvas: NSViewRepresentable {
    func makeNSView(context: Context) -> TouchTrackingView { TouchTrackingView() }
    func updateNSView(_ nsView: TouchTrackingView, context: Context) {}
}

@MainActor
final class TouchTrackingView: NSView {
    private var contacts: [NSTouch] = []
    private var deviceSize = NSSize.zero

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        allowedTouchTypes = [.indirect]
        wantsRestingTouches = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    override var acceptsFirstResponder: Bool { true }
    override var isFlipped: Bool { false }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        window?.makeFirstResponder(self)
    }

    override func touchesBegan(with event: NSEvent) { update(event) }
    override func touchesMoved(with event: NSEvent) { update(event) }
    override func touchesEnded(with event: NSEvent) { update(event) }
    override func touchesCancelled(with event: NSEvent) { update(event) }

    private func update(_ event: NSEvent) {
        contacts = Array(event.touches(matching: .touching, in: self))
        if let first = contacts.first, first.deviceSize != .zero {
            deviceSize = first.deviceSize
        }
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        NSColor.windowBackgroundColor.setFill()
        dirtyRect.fill()

        let pad = padRect()
        NSColor.controlBackgroundColor.setFill()
        NSBezierPath(roundedRect: pad, xRadius: 18, yRadius: 18).fill()
        NSColor.separatorColor.setStroke()
        let outline = NSBezierPath(roundedRect: pad, xRadius: 18, yRadius: 18)
        outline.lineWidth = 1
        outline.stroke()

        drawFingers(in: pad)
        drawStatus()
    }

    private func padRect() -> NSRect {
        let inset: CGFloat = 40
        let available = bounds.insetBy(dx: inset, dy: inset)
        let aspect = deviceSize.height > 0 ? deviceSize.width / deviceSize.height : 1.55
        var pad = NSRect(x: 0, y: 0, width: available.width, height: available.width / aspect)
        if pad.height > available.height {
            pad = NSRect(x: 0, y: 0, width: available.height * aspect, height: available.height)
        }
        pad.origin = NSPoint(
            x: available.midX - pad.width / 2,
            y: available.midY - pad.height / 2
        )
        return pad
    }

    private func drawFingers(in pad: NSRect) {
        let radius: CGFloat = 20
        for (index, touch) in contacts.enumerated() {
            let position = touch.normalizedPosition
            let center = NSPoint(
                x: pad.minX + CGFloat(position.x) * pad.width,
                y: pad.minY + CGFloat(position.y) * pad.height
            )
            let dot = NSBezierPath(
                ovalIn: NSRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: radius * 2,
                    height: radius * 2
                )
            )
            NSColor.controlAccentColor.withAlphaComponent(touch.isResting ? 0.45 : 0.9).setFill()
            dot.fill()

            drawText(
                "\(index + 1)",
                at: NSPoint(x: center.x - 4, y: center.y - 8),
                font: .monospacedDigitSystemFont(ofSize: 13, weight: .bold),
                color: .white
            )
        }
    }

    private func drawStatus() {
        drawText(
            "Fingers: \(contacts.count)",
            at: NSPoint(x: 20, y: bounds.maxY - 30),
            font: .monospacedDigitSystemFont(ofSize: 16, weight: .semibold),
            color: .labelColor
        )

        let lines = contacts.enumerated().map { index, touch in
            let p = touch.normalizedPosition
            return String(format: "%d: x %.2f  y %.2f", index + 1, p.x, p.y)
        }
        for (row, line) in lines.enumerated() {
            drawText(
                line,
                at: NSPoint(x: 20, y: 18 + CGFloat(row) * 16),
                font: .monospacedDigitSystemFont(ofSize: 12, weight: .regular),
                color: .secondaryLabelColor
            )
        }

        if contacts.isEmpty {
            drawText(
                "Touch the trackpad",
                at: NSPoint(x: 20, y: 18),
                font: .systemFont(ofSize: 13),
                color: .tertiaryLabelColor
            )
        }
    }

    private func drawText(_ text: String, at point: NSPoint, font: NSFont, color: NSColor) {
        NSAttributedString(
            string: text,
            attributes: [.font: font, .foregroundColor: color]
        ).draw(at: point)
    }
}
