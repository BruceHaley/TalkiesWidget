import SwiftUI
import UIKit

@main
struct TalkiesWidgetApp: App {
    @State private var launchedFromWidget = false

    var body: some Scene {
        WindowGroup {
            Group {
                if launchedFromWidget {
                    Color.black.ignoresSafeArea()
                } else {
                    ContentView()
                }
            }
            .onOpenURL { url in
                // We receive namewidget://bot?botName=X
                // Extract the botName and refire as talkies://bot?botName=X
                guard url.scheme == "namewidget",
                      url.host == "bot",
                      let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                      let botName = components.queryItems?.first(where: { $0.name == "botName" })?.value,
                      let encoded = botName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                      let talkiesURL = URL(string: "talkies://bot?botName=\(encoded)")
                else { return }

                launchedFromWidget = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    UIApplication.shared.open(talkiesURL, options: [:])
                }
            }
        }
    }
}
