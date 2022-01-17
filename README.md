# A Simple Search App
A native iOS app that hits endpoints from the free Deezer API to retrieve musician information, which is then displayed in a simple UI.

## Walkthrough

Simply clone the project and run from Xcode on an iPhone simulator!

The app was built with default colors that allow you to view the app in light or dark mode, so you can choose your preference for the experience.

The landing screen should be updated to include a welcoming interface, drawing users into the app. For now, I've included a straightforward search interface that allows you to search for an artist.
|Home|Artist Search|
|-|-|
|<img width="350" alt="Screen Shot 2022-01-17 at 1 37 04 PM" src="https://user-images.githubusercontent.com/11492766/149823281-c85d1c83-a6a9-4a9c-8cec-6d2a2b90fcfa.png">|<img width="350" alt="Screen Shot 2022-01-17 at 1 37 12 PM" src="https://user-images.githubusercontent.com/11492766/149823405-08a5c33e-65f7-4a00-956c-20e6f904ae0d.png">|

Upon selecting an artist, you are taken to the artist's discography.

<img width="350" alt="Screen Shot 2022-01-17 at 1 37 20 PM" src="https://user-images.githubusercontent.com/11492766/149823432-84d13bfa-3663-4993-9e41-04a8ab81d240.png">

Selecting a specific album shows you the album's tracklist.

<img width="350" alt="Screen Shot 2022-01-17 at 1 37 27 PM" src="https://user-images.githubusercontent.com/11492766/149823469-80bc8b9a-a8f1-4785-89e8-af380b6ff78e.png">


## Architecture Decisions

Since this app was built as an MVP and under a time limit, there is a simple architecture being used to separate the Views, Controllers, Models, and API layers. Features have been separated into their own groups, and global classes are at the base layer of the project (with a bigger project this files should be moved into a Core/Common type of group).

Ideally, and perhaps in the future, display logic would be pulled into a separate, testable class. For now, the display logic is so simple, that it's contained in the controllers.

Additionally, the networking layers (NetworkingProviders) have all been built conforming to protocols. This would allow future engineers to swap out the networking class instance for testing purposes (since we aren't yet using a view logic class, we aren't testing the controllers directly).

For a larger project that needs to be scaled, I'd like to pull out the strings and the UI constants (colors, sizes) into a localizable strings file and design system class respectively.

Lastly, given incomplete designs, I opted to also remove a search bar from each screen. This would require a more complicated architecture, and provides a confusing user experience (for example, I would expect that searching from the tracklist screen wouldn't let me search for a different artist). For the tracklist screen I also have excluded the album image for now since it required more design decisions about how to show the image (do we want it to scroll with the rest of the view, or disappear/blur as we scroll?). This combined with the unknowns of how to handle the navigation bar, it didn't seem significant to leave out the album cover at this time. I also added notes throughout the project for error handling, but didn't want to spend extra time creating/implementing real designs for the edge cases.
