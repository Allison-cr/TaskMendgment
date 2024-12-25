# Dairy App

Dairy App is a task management application built using Swift, RxSwift, and Realm. It features a calendar-based interface for organizing daily tasks, loading data from a JSON file, and persisting data locally using Realm.

<div style="display: flex; justify-content: space-between;">
    <img src="Images/screen1.png" alt="Screenshot 1" width="300" style="margin-right: 10px;"/>
    <img src="Images/screen2.png" alt="Screenshot 2" width="300" style="margin-right: 10px;"/>
    <img src="Images/screen3.png" alt="Screenshot 3" width="300"/>
</div>

## Features

- **Calendar-Based Task Management**:  
  Navigate tasks by day, and view tasks associated with a specific date.  
- **Task**   
  Tap on the task to open the detailed screen. You can delete or edit task.
- **Add button**  
 You can add tasks via the plus button at the top. After clicking, a modal window will open, enter the data, the save will automatically add to the screen and save to the Realm database.
- **Collection**   
 If the tasks stack up, the collection will automatically add a column to display the tasks .


- **Local Data Persistence**:  
  Task data is stored and managed using Realm, ensuring a seamless offline experience.

- **JSON Data Import**:  
  Preload tasks from a JSON file into the database on first launch.

- **Reactive Programming**:  
  Built with RxSwift for reactive and declarative UI updates.

- **Dynamic Date Handling**:  
  Automatically updates the task list based on the currently selected date.

## Getting Started

### Prerequisites

- Xcode 15 or later
- Swift 5.7 or later
- CocoaPods (for dependency management)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/Dairy.git
   cd Dairy
   ```

2. **Install dependencies**:
    ```bash
    pod install
    ```
3. **Open the workspace**:

    ```bash
    open Dairy.xcworkspace
    ```

4. **Run the app: Select a simulator or a connected device and hit Run in Xcode.**

## Data Setup
Ensure the JSON file data.json is included in your project bundle. The app will automatically load data from this file into the local Realm database on first launch.

### Usage
Navigate through the calendar to select a specific day.
View tasks scheduled for the selected date.
Tasks dynamically update when the Realm database is modified.
Code Overview
Key Components
MainViewModel:
Handles business logic and data fetching. Includes methods for managing tasks and observing database changes.

## Realm Integration:
Tasks are stored in a local Realm database, enabling persistent storage and real-time updates.

## RxSwift Observables:
Utilizes BehaviorRelay for reactive state management.

## Folder Structure
   ```bash
Dairy
├── Application   # App lifecycle management
         ├── AppDelegate # Manages app's main lifecycle events 
         └── SceneDelegate # Manages scenes in multi-scene applications (iOS 12+)
├── Utils  # Custom view
├── NavigationLayer  # Navigation layer
         └── MainCoordinator # Handles screen transitions and navigation flow 
└── Screens
         ├── MainScreen # Main Screen
               ├── MainViewController  # UI for the main screen
               ├── MainViewModel # Business logic and task management for the main screen 
               └── Model # Data models for tasks
         ├── ModalView  # UI Screen for add task
         └── TaskDetailViewController  # Detail screen for displaying a task's info
```
### Dependencies
- **RxSwift**  
- **Realm**