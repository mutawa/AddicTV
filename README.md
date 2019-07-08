# AddicTV : The app for TV Addicts

This app will make it easy for any user to search TVMaze database of all TV shows, and view information about the shows, like the release date, genre, and plot synposes. The app also provides a way to visually identify shows by a small thumbnail image, nad a higher resolution poster.


# Implementation

Once the app is launched for the first time, the user will be in the Search view controller. 
A friendly message will guide the user as to what should be done. The user may start by searching for any particular show.
The TVMaze API will try to match the search term with its database and will provide search results for the user to select and see more details. 

If the API fails to find any matches, a freindly message is displayed to the user to let them know that the search used could not be matched. The message is updated with each change of the SearchBar textfield, so the user has constant feedback.

If however, the API fails to access the Internet, another message appears to inform the user.

Everytime there is a network acitivity, an activity indicator (spinner) is displayed until the communication is stopped.

Once a show is selected from the search result, the user will be presented to the Show view controller, where a summary of the plot synopses is displayed along with a higher resoultion image of the poster. Once the higher resolution image is downloaded, it is temporarly stored. 

The app also checks if the selected show has previously been added to the user's favorite list. If not, a star button is added to the top right of the Show view controller to let the user easily add the show. Once the button is tapped, it the star is filled and stays filled for 1 second before the button is disabled, as a visual feedback to confirm to the user that the showhas been added to his/her favorite list.

If the user tabs the (Favorites) tab from UITabBarController, the Favorites view controller will be displayed.
If it is empty when that happens, a freindly message is dsiplayed. 

The list of favorite shows is stored in CoreData. Meaning, no network connection is required to view and read the favorite shows. 

The user can easily edit the favorite shows list by deleting or adding new shows via the search tab.


# How to build

In XCode, build and run by holding Command ⌘ + R

# Requirements

Xcode 10.2

Swift 4.2

iOS 12.0 +

# License

MIT license
