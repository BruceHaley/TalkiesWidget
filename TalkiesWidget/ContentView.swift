import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var names: [String] = []
    @State private var newName: String = ""
    @State private var showingAdd = false
    @FocusState private var fieldFocused: Bool

    var body: some View {
        NavigationStack {
            List {
                if names.isEmpty {
                    ContentUnavailableView(
                        "No Bots Yet",
                        systemImage: "person.crop.circle.badge.plus",
                        description: Text("Tap + to add a bot name")
                    )
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(names, id: \.self) { name in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundStyle(Color(red: 0.914, green: 0.271, blue: 0.376))
                            Text(name)
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                        }
                        .padding(.vertical, 2)
                    }
                    .onDelete(perform: deleteName)
                    .onMove(perform: moveName)
                }
            }
            .navigationTitle("Bots")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Add Bot", isPresented: $showingAdd) {
                TextField("Name", text: $newName)
                Button("Add") { addName() }
                Button("Cancel", role: .cancel) { newName = "" }
            } message: {
                Text("Enter a name to add to the widget picker.")
            }
        }
        .onAppear(perform: load)
    }

    // MARK: - Actions

    private func load() {
        BotsJsonFile.seedIfNeeded()
        names = BotsJsonFile.loadNames()
    }

    private func addName() {
        let trimmed = newName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !names.contains(trimmed) else {
            newName = ""
            return
        }
        names.append(trimmed)
        persist()
        newName = ""
    }

    private func deleteName(at offsets: IndexSet) {
        names.remove(atOffsets: offsets)
        persist()
    }

    private func moveName(from source: IndexSet, to destination: Int) {
        names.move(fromOffsets: source, toOffset: destination)
        persist()
    }

    private func persist() {
        BotsJsonFile.saveNames(names)
        // Reload widget timelines so the picker reflects changes
        WidgetCenter.shared.reloadAllTimelines()
    }
}

#Preview {
    ContentView()
}
