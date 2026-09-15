# 🎬 Movie App

A Flutter movie application built during my NTI Flutter training. The
app allows users to discover movies, search for titles, view movie
details, and manage a personal watch list.

## ✨ Features

-   🎬 Splash Screen
-   🏠 Home screen with a movie carousel
-   🔥 Now Playing movies
-   🎞️ Upcoming movies
-   ⭐ Top Rated movies
-   🔥 Popular movies
-   🔍 Search for movies
-   📖 Movie details with ratings and information
-   ❤️ Add and remove movies from the Watch List
-   💾 Persistent Watch List using SharedPreferences
-   👤 Guest session handling
-   🌐 Dynamic movie data from the TMDB API

## 🛠️ Technologies & Tools

-   **Flutter**
-   **Dart**
-   **BLoC / Cubit** for state management
-   **Dio** for API requests
-   **TMDB API** for movie data
-   **SharedPreferences** for local Watch List storage
-   **REST API**
-   **JSON**

## 📱 App Sections

### Splash Screen

Introduces the application before navigating to the main movie
experience.

### Home

Browse movies through Now Playing, Upcoming, Top Rated, and Popular
categories.

### Search

Search for movies and open their details directly from the results.

### Movie Details

View movie information, poster, rating, overview, and add the movie to
the Watch List.

### Watch List

Save movies and access them later. The Watch List is stored locally
using SharedPreferences.

## 🔄 App Flow

**Splash → Home → Movie Details → Watch List**

The app also provides navigation for Home, Search, and Watch List.

## 🚀 Getting Started

### Prerequisites

Make sure Flutter is installed and configured on your machine.

### Clone the repository

``` bash
git clone https://github.com/ayakaram39/Movie_App.git
```

### Open the project

Open the cloned project in Android Studio or your preferred Flutter IDE.

### Install dependencies

``` bash
flutter pub get
```

### Run the application

``` bash
flutter run
```

## 🔗 Repository

GitHub: https://github.com/ayakaram39/Movie_App

## 🎓 Training

This project was developed as part of my Flutter training at **NTI --
Shebin El-Kom, Menoufia**.

## 👩‍💻 Developer

**Aya Karam**

Machine Learning Student \| Flutter Developer
