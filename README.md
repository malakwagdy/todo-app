# Flutter To-Do App

A responsive and modern cross-platform To-Do application built with Flutter. This project is designed to showcase a clean UI, fluid state management, and a responsive layout that adapts seamlessly to mobile, tablet, and desktop screen sizes.

## Screenshots

| Mobile View (Narrow Layout) | Desktop View (Wide Layout) |
| :-------------------------: | :--------------------------: |
| ![Mobile View](link/to/your/mobile_screenshot.png) | ![Desktop View](link/to/your/desktop_screenshot.png) |

## Key Features

- **Responsive & Adaptive UI:** The layout gracefully transitions from a single-column mobile view to a two-column desktop view with a sidebar.
- **Dynamic Content:** To-do items and tasks are built dynamically from a central state list.
- **Full CRUD Functionality:** Users can **C**reate (add), **R**ead (view), **U**pdate (toggle completion), and **D**elete to-do lists.
- **Stateful Logic:** The UI automatically updates in real-time when a task's status changes, syncing the pending/done counters.
- **Dynamic Task Input:** The "Add To-Do" dialog allows users to add a variable number of tasks to any new to-do item.
- **Custom Painting:** Features custom-drawn circular progress bars to visualize the completion statistics for both to-dos and individual tasks.
- **Efficient Scrolling:** Utilizes `Slivers` (`CustomScrollView`, `SliverGrid`, `SliverList`) for high-performance scrolling in all layouts.
- **Internally Scrollable Cards:** Each to-do card can scroll internally if its list of tasks is too long to fit, preventing UI overflow errors.

## Built With

- **[Flutter](https://flutter.dev/)** - The cross-platform UI toolkit for building the application.
- **[Dart](https://dart.dev/)** - The programming language used.

### Core Concepts Implemented:

- **State Management:** Using `StatefulWidget` and the `setState` method for clean and simple state updates.
- **Responsive UI:** Leveraging `LayoutBuilder` and `MediaQuery` to create adaptive layouts.
- **Custom Painting:** Using `CustomPainter` to draw unique UI elements like the progress circles.
- **Advanced Scrolling:** Implementing `Slivers` for efficient and flexible list and grid views.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- You must have the Flutter SDK installed on your machine. For instructions, see the [official Flutter documentation](https://flutter.dev/docs/get-started/install).

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/your-repo-name.git
    ```
2.  **Navigate to the project directory:**
    ```sh
    cd your-repo-name
    ```
3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```
4.  **Run the app:**
    ```sh
    flutter run
    ```

## License

Distributed under the MIT License. See `LICENSE` for more information.
