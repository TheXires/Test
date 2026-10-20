# Einkaufsliste

Eine einfache native iOS-Einkaufslisten-App mit SwiftUI.

- Artikel hinzufügen (doppelte offene Artikel erhöhen die Menge)
- Abhaken / wieder öffnen per Tipp
- Löschen per Wischgeste, „Erledigte löschen“ in der Toolbar
- Liste wird lokal als JSON gespeichert

## Aufbau

| Pfad | Inhalt |
| --- | --- |
| `Packages/ShoppingListKit` | Plattformunabhängige Logik (Modell, Speicherung) + Unit-Tests, läuft auch unter Linux |
| `App` | SwiftUI-App (View, ViewModel) |
| `AppTests` | Unit-Tests für das ViewModel |
| `UITests` | UI-Test im iOS-Simulator |
| `project.yml` | XcodeGen-Spezifikation für das Xcode-Projekt |

## Lokal bauen (macOS)

```sh
brew install xcodegen
xcodegen generate
open ShoppingList.xcodeproj
```

Nur die Logik testen (macOS oder Linux):

```sh
swift test --package-path Packages/ShoppingListKit
```

## CI

`.github/workflows/ci.yml` führt bei jedem Push aus:

1. Package-Tests unter Linux (`swift:6.0`-Container)
2. Auf einem macOS-Runner: Package-Tests, Projekt mit XcodeGen erzeugen, App bauen und Unit- und UI-Tests im iOS-Simulator ausführen
