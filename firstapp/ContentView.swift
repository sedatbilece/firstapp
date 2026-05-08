//
//  ContentView.swift
//  firstapp
//
//  Created by Sedat Bilece on 8.05.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var newTitle = ""

    var completedCount: Int {
        items.filter { $0.isCompleted }.count
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    TextField("Yeni görev ekle...", text: $newTitle)
                        .textFieldStyle(.roundedBorder)
                    Button("Ekle") {
                        addItem()
                    }
                    .disabled(newTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()

                if !items.isEmpty {
                    Text("\(completedCount) / \(items.count) tamamlandı")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)
                }

                List {
                    ForEach(items) { item in
                        HStack {
                            Button {
                                toggleItem(item)
                            } label: {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.isCompleted ? .green : .gray)
                                    .font(.title3)
                            }
                            .buttonStyle(.plain)

                            Text(item.title)
                                .strikethrough(item.isCompleted)
                                .foregroundColor(item.isCompleted ? .secondary : .primary)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("Yapılacaklar")
            .toolbar {
                EditButton()
            }
        }
    }

    private func addItem() {
        let trimmed = newTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        withAnimation {
            modelContext.insert(Item(title: trimmed))
            newTitle = ""
        }
    }

    private func toggleItem(_ item: Item) {
        withAnimation {
            item.isCompleted.toggle()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
