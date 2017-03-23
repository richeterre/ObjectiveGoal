ObjectiveGoal
=============

[![Sponsored](https://img.shields.io/badge/chilicorn-sponsored-brightgreen.svg)](http://spiceprogram.org/oss-sponsorship/)

This project was inspired on a theoretical level by Justin Spahr-Summers' talk [Enemy of the State](https://github.com/jspahrsummers/enemy-of-the-state), and on a more practical one by Ash Furrow's [C-41](https://github.com/ashfurrow/C-41) app. It showcases the Model-View-ViewModel (MVVM) architecture while serving as a digital logbook of football matches, both [physical](http://en.wikipedia.org/wiki/Association_football) and [virtual](http://en.wikipedia.org/wiki/FIFA_(video_game_series)).

Using Objective-C instead of Swift was a conscious decision based on own and [others'](http://artsy.github.io/blog/2014/11/13/eidolon-retrospective/) experiences, especially with tooling and general development speed. However, as the new language matures, its great suitability for functional reactive programming (for example, its emphasis on type safety) will make a Swift port a natural next step.

Setup
-----

The application uses [Goalbase](https://github.com/richeterre/goalbase) as a backend to store, process and retrieve information. It assumes you have a Goalbase instance running at `http://localhost:3000`, which is the default URL of the WEBrick server that ships with Rails. Please check out the [Goalbase documentation](https://github.com/richeterre/goalbase/blob/master/README.md) for more detailed instructions.

If you want to provide your own backend, simply change the base URL path in `APISessionManager.m`.

Architecture
------------

__Model__: Due to the rather simple nature of the app, two models are enough to hold its information: `Player` and `Match`. A `Player` is uniquely identified by its UUID, and has a name that is shown in the UI. Each `Match` holds a set home and away players along with the result. Both matches and players are vended by the `APIClient`.

__View__: Each view controller corresponds to an app screen, which in turn is represented visually in the Storyboard. Most transitions, typically pushing to a navigation stack, are handled here through segues. The view model associated with a pushed view controller is set up in the `prepareForSegue:` method.

__ViewModel__: With the exception of the `SelectPlayersViewModel`, each view model corresponds to a single view controller. It exposes _methods_ that provide content, _signals_ that provide time-variable information such as the presence of a progress indicator for ongoing requests, and _commands_ that map button actions to signals representing their execution, e.g. when adding new matches.

The `SelectPlayersViewModel` stands out in that it handles two distinct tasks: displaying a list of players, and adding new ones to the list. As both act on the same data, splitting these tasks would create some unnecessary overhead. Instead, a list refresh is triggered every time a new player is added.

__Others:__ Notable is the almost complete absence of singletons, as they basically constitute global state. The only singleton is the app delegate, which serves as an entry point to inject view models and a common API client into the top-level view controllers. The latter is then passed onwards as the user navigates through the app. A few helper classes that encapsulate common tasks round out the picture.

Benefits of MVVM
----------------

__High testability:__ The basic premise of testing is to verify correct output for a given input. As a consequence, any class that minimizes the amount of dependencies affecting its output becomes a good candidate for testing. MVVM's separation of logic (the view model layer) from presentation (the view layer) means that the view model can be tested with minimal setup. For instance, injecting a mock `APIClient` that provides `Match` instances is enough to verify that the `MatchesViewModel` reports the correct amount of matches. The view layer becomes trivial, as it simply binds to those outputs.

__Better separation of concerns:__ `UIViewController` and its friends have been rightfully scorned for handling far too many things, from interface rotation to networking to providing table data. MVVM solves this by making a clear cut between UI and business logic. While a view controller would still acts as its table view's data source, it forwards the actual data queries to its own view model. Presentation details, such as animating new rows into the table view, will be handled in the view layer.

__Encapsulation of state:__ As suggested by Gary Bernhardt in his famous talk [“Boundaries”](https://www.destroyallsoftware.com/talks/boundaries), view models offer a stateful shell around the stateless core of the app, the model layer. If need be, the app's state can be persisted and restored simply by storing the view model. While the view may be extremely stateful too, its state is ultimately derived from that of the view model, and thus does not require to be stored.

Shortcomings
------------

* There is a fair amount of similar-looking code across view models and view controllers, e.g. for displaying and hiding a progress HUD. Perhaps parts of this code could be moved to a common superclass.

License
-------

This project is available under the [MIT license](http://choosealicense.com/licenses/mit/).
