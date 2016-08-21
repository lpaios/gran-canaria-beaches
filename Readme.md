#Instructions to run the project
1. Install libraries:
`pod install`
2. add this file [GoogleService-Info.plist](https://grancanariabeaches.baulen.com/GoogleService-Info.plist) to playas folder
3. run the project and enjoy

# UIControl
There are three uicontrols:
1. Activity in pull and refresh in the list view.
2. Switch control in settings page. It allow you hide or show the description in detail view.
3. UIButton in login page.

# Activities
Always I make a network request (even in uiwebview), I show my custom activity. It disappear when the request has finished.
At the same time we show the activity in the status bar

# Alerts
I show my custom alert always that the network request fails


# Gran Canaria Beaches
If we don't have a Photo for one beach, we show Google Street Maps Photo.
The images are saved in coredata field, with checkbox for saving to disk.

## API Integrated
- Google Street Maps: To get missing maps
- Firebase: As database webservice
- Aemet: to get weather and temperatures

## Discover
Discover the most secret beaches in Gran Canaria

![Discover](https://grancanariabeaches.baulen.com/repository/gran-canaria-beaches-map.jpg "Discover")

## List
You can wath the list of the all the beaches.
*Pull*
You can pull the list to refresh it.

![List](https://grancanariabeaches.baulen.com/repository/gran-canaria-beaches-list.jpg "List")

## Detail
Check the current weather, water temperature and Ultraviolet index (electromagnetic radiation)
You can show or hide the description in settings tab

![Detail](https://grancanariabeaches.baulen.com/repository/gran-canaria-beaches-detail.jpg "Detail")

## Settings
Check out more about me (the developer) and the origin of the data.
Here 

![Settings](https://grancanariabeaches.baulen.com/repository/gran-canaria-beaches-settings.jpg "Settings")

## Login Facebook
You can login with facebook to receive news in you email.
If you want, you can use this credentials
- user: antonio2@sejas.es
- password: udacity

![Login](https://grancanariabeaches.baulen.com/repository/gran-canaria-beaches-login.jpg "Login")