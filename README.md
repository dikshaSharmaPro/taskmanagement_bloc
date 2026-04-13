# Task Management App

A premium and intuitive Task Management App built using **Flutter**, powered by **BLoC** for state management and directly integrated with **Supabase** for real-time backend operations.

---

## Features

- **Real-time Synchronization**: Instant updates across devices using Supabase real-time streams.
- **Task Management**: Add, edit, and delete tasks with a clean, intuitive interface.
- **Sorting & Filtering**: Organize tasks by date, completion status, or priority.
- **Visual Analytics**: Interactive pie charts to track task progress using `fl_chart`.
- **Premium UI**: Dark-themed, glassmorphic design with smooth animations and micro-interactions.

---

## Architecture

This project follows a feature-based architecture combined with the **BLoC (Business Logic Component)** pattern for clean separation of concerns.

### State Management (BLoC)
- **Predictable State**: All UI states are derived from BLoC states, ensuring a one-way data flow.

- **Decoupled Logic**: Business logic (sorting, task manipulation) is kept entirely separate from the UI widgets.

### Backend Integration
- **Supabase Realtime**: The app leverages Supabase's `stream` functionality to listen for changes in the PostgreSQL database.
- **Service Layer**: Centralized logic in `AuthService` and `AppLogic` for database interactions.

---

## Why Supabase instead of Firebase?

I chose **Supabase** as the backend for several key reasons:

1. **Relational Database (PostgreSQL)**: Unlike Firebase's NoSQL Firestore, Supabase is built on PostgreSQL. This allows for complex relational queries, strict data types, and powerful SQL capabilities.
2. **Row Level Security (RLS)**: Security is handled at the database level. Using PostgreSQL RLS policies, we ensure users can only access their own data via JWT authentication.
3. **Real-time SQL**: Supabase provides real-time updates for standard SQL queries, making it easier to build reactive features without the limitations of NoSQL nesting.
4. **Open Source & Portability**: Supabase is open-source and provides a suite of tools (PostgREST, GoTrue) that can be self-hosted or migrated more easily than proprietary Firebase services.

---

## Setup Instructions

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
- [Supabase Account](https://supabase.com/) for backend services.

### Steps

1. **Clone the Repository**:
   

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Supabase Database Setup**:
   - Create a new project in Supabase.
   - Run the following SQL in the SQL Editor to create the tasks table:
     ```sql
     create table tasks (
       id uuid primary key default uuid_generate_v4(),
       title text not null,
       description text,
       datetime text,
       "isCompleted" boolean default false,
       user_id uuid references auth.users(id) on delete cascade
     );
     -- Enable Realtime
     alter publication supabase_realtime add table tasks;
     -- Enable RLS
     alter table tasks enable row level security;
     ```

4. **Configuration**:
   - Create a file `lib/env.dart`.
   - Add your Supabase credentials:
     ```dart
     const supabaseUrl = 'YOUR_SUPABASE_URL';
     const supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
     ```

5. **Run the App**:
   ```bash
   flutter run
   ```

---

## Tech Stack

- **Flutter** & **Dart**
- **BLoC** (State Management)
- **Supabase** (PostgreSQL, Auth, Realtime)
- **fl_chart** (Data Visualization)
- **uuid** (ID Generation)
- **intl** (Date Formatting)
