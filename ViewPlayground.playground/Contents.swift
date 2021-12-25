import SwiftUI
import PlaygroundSupport

struct ContentView: View {
  var body: some View {
    VStack(alignment: .leading) {
      Group {
        Group {
          Text("Large Title")
            .font(.largeTitle)
          Text("Title")
            .font(.title)
          Text("Title 2")
            .font(.title2)
          Text("Title 3")
            .font(.title3)
        }
        Group {
          Text("Headline")
            .font(.headline)
          Text("Subheadline")
            .font(.subheadline)
        }
        Text("Body")
          .font(.body)
        Text("Callout")
          .font(.callout)
        Text("Footnote")
          .font(.footnote)
        Group {
          Text("Caption")
            .font(.caption)
          Text("Caption 2")
            .font(.caption2)
        }
      }
      .padding(2)
    }
  }
}

PlaygroundPage.current.setLiveView(ContentView())
