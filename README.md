# AddicTV: get Addicted to TV shows easily

AddicTV is an app that lets any user search TVMaze database, and read the synopses of the show. 

The app enables the user to read release data, genres, etc.

When launched for the first time, the user will be prompted to lookup any show using the Search Bar in the Search View Controller.

If the search term was not matched with any resutl, the user will be notified, in a un-obstrutive way.

If for some reason, the API was unable to access the internet, the user will receive a feedback in the same manner.

The user can select any show from the result, a segue will take place to view the show poster in higher resolution,
as well as a summary of the show's synopses. The high resolution poster image might take some time to load. An activity
indicator is displayed for the user to let him/her know that a network call is in-progress.

Once all data is retrieved, the app will check if the show has previously been added to the user's list of favorite shows.

If not, an Add button [+] will appear on the top right corner of the view controller to all the user to do so.

Once the button is tapped, it will disappear to give feedback to the user that the action has been carried out.

The user can select the second tab of the TabBarController to see a list of the shows that were added.

These shows are loaded from CoreData, and are editable. This means that the user doesn't have to be connected to the Internet 
to read synopses or see high resolution poster of the favorite shows.

The user can also remove/delete shows from the favorite list. 
Once the user has deleted the last show, a default placeholder label will be displayed to give a better experience.

The default/placeholder cells is un-editable, and un-selectable in all view controllers.

If the user selects a cell containing a favorite show, a segue will take place to the shows details view controller.

However, this time the show will be passed to the destination view controller as a CoreData object, as opppsed to from the API 
network call. The destination controller handles objects from CoreData and from API just the same, via the magic of protocols.

A great deal of care went to the writing of code that makes sure that asyncronous calls to the network ensures that
thumbnails of dequeued cells are updated only if they still are grabbing their own model that was available before the
network API call was initiated. This means, there won't be any weired UI experience for the user.



