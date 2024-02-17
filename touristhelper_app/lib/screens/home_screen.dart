import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:touristhelper_app/home/user.dart';
import 'package:touristhelper_app/home_app_bar.dart';
import 'package:touristhelper_app/home_bottom_bar.dart';
import 'package:touristhelper_app/widgets/favourites.dart';
import 'package:touristhelper_app/widgets/registerplace.dart';
import 'package:touristhelper_app/widgets/viewlocation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatelessWidget {
  final User user;

  HomePage({super.key, required this.user});
  final List<String> containerTexts = [
    'Kuala Lumpur',
    'Terengganu',
    'Sarawak',
    'Kedah',
    'Johor',
    'Sabah',
    'Melaka',
    'Langkawi',
    'Pahang'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: HomeAppBar(
          user: user,
        ),
      ),
      bottomNavigationBar: HomeBottomBar(
        user: user,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: 9,
        itemBuilder: (BuildContext context, int index) {
          //  unique identifier as the Hero tag, in this case, the image path
          String imagePath = 'images/city${index + 1}.jpg';
          String imagePath2 = 'images/city${index + 10}.jpg';
          String heroTag = 'cityImage$index';

          return GestureDetector(
              onTap: () {
                print("user is here and his name is ${user.displayName}");
                // Navigate to a detailed screen or show a larger image
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      user: user,
                      imagePath: imagePath2,

                      heroTag: heroTag,

                      names: [
                        'Kuala Lumpur',
                        'Terengganu',
                        'Sarawak',
                        'Kedah',
                        'Johor',
                        'Sabah',
                        'Melaka',
                        'Langkawi',
                        'Pahang'
                      ], // Add more names as needed
                      descriptions: [
                        'Kuala Lumpur is the capital and largest city of Malaysia, situated in the western part of Peninsular Malaysia. As a vibrant and cosmopolitan metropolis, Kuala Lumpur serves as the economic, cultural, and financial hub of the country',
                        'Terengganu is a state located on the northeastern coast of Peninsular Malaysia. It is known for its rich cultural heritage, beautiful beaches, traditional architecture, and a strong connection to Malaysias Malay traditions. ',
                        'Sarawak is the largest state in Malaysia, located on the island of Borneo. Known for its diverse cultures, rich biodiversity, and unique landscapes, Sarawak offers a mix of modern development and traditional charm',
                        'Kedah is a state located in the northern part of Peninsular Malaysia. Known as the "Rice Bowl of Malaysia," Kedah is recognized for its agricultural significance, historical heritage, and cultural attractions. ',
                        'Johor is a state located at the southern tip of Peninsular Malaysia, sharing a border with Singapore. It is the third-largest state in Malaysia and plays a significant role in the countrys economy and development. ',
                        'Sabah is a state situated on the northern part of the island of Borneo, in Malaysia. Known for its diverse landscapes, rich biodiversity, and vibrant cultural heritage, Sabah is a popular destination for nature enthusiasts and adventure seekers.',
                        'Melaka, also spelled Malacca, is a historic state and city located on the southwestern coast of Peninsular Malaysia. Known for its rich cultural heritage, colonial history, and diverse influences, Melaka has been recognized as a UNESCO World Heritage Site',
                        'Langkawi is an archipelago of 99 islands in the Andaman Sea, about 30 kilometers off the northwestern coast of Peninsular Malaysia. Known as the "Jewel of Kedah," Langkawi is a popular tourist destination.',
                        'Pahang is the largest state in Peninsular Malaysia and is known for its diverse landscapes, including mountains, rainforests, and beautiful coastlines. The state offers a range of natural attractions, cultural experiences, and outdoor activities',
                      ], // Add more descriptions as needed
                      index: index, // Pass the index of the clicked image
                    ),
                  ),
                );
              },
              child: Hero(
                tag: heroTag,
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      containerTexts[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 196, 183, 69),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
      backgroundColor: Color.fromARGB(255, 26, 119, 156),
    );
  }
}

void navigateToRegisterPlacePage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          RegisterPlacePage(), // Replace with the actual route for the register place page
    ),
  );
}

class DetailScreen extends StatefulWidget {
  final User user;
  final String imagePath;
  final String heroTag;
  final List<String> names;
  final List<String> descriptions;
  final int index;

  const DetailScreen({
    Key? key,
    required this.user,
    required this.imagePath,
    required this.heroTag,
    required this.names,
    required this.descriptions,
    required this.index,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final PlaceDatabase placeDatabase = PlaceDatabase();

  double rating = 4; // can replace this with the actual rating value
  bool showFunFact = false;
  bool isFavorited =
      false; // New variable to track whether the location is favorited

  void addToFav(String placeName) async {
    final url = Uri.https(firebaseUrl, "fav.json");

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'placeName': placeName,
            },
          ));
      if (response.statusCode == 200) {
        print("Place is registered");
      }
    } catch (error) {
      print("error $error");
    }
  }

  void registerPlace(String placeName) async {
    final url = Uri.https(firebaseUrl, "registerPlaces.json");

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'placeName': placeName,
          },
        ));
    if (response.statusCode == 200) {
      print("Place is registered");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.names[widget.index]),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.grey,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Hero(
                tag: widget.heroTag,
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the register place page
                navigateToRegisterPlacePage(context);
                placeDatabase.registerPlace(widget.names[widget.index]);
// Show a confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Place Registered"),
                      content: Text(
                          "${widget.names[widget.index]} has been registered."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // go back here\
                            registerPlace(widget.names[widget.index]);
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Register Now'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.names[widget.index],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.descriptions[widget.index],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Feedback and Rating',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          showFunFact
                              ? Icons.lightbulb
                              : Icons.lightbulb_outline,
                          color: showFunFact ? Colors.yellow : Colors.grey,
                        ),
                        onPressed: () {
                          if (showFunFact) {
                            // Navigate to ViewLocationPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewLocationPage(),
                              ),
                            );
                          } else {
                            // Toggle the fun fact visibility
                            setState(() {
                              showFunFact = !showFunFact;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  if (showFunFact)
                    Column(
                      children: [
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (newRating) {
                                setState(() {
                                  rating = newRating;
                                });
                              },
                            ),
                            SizedBox(width: 8),
                            Text(
                              rating.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Fun Fact: This is a fun fact related to ${widget.names[widget.index]}!',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.red : null,
                        ),
                        onPressed: () {
                          // Toggle the favorites status
                          setState(() {
                            isFavorited = !isFavorited;
                          });
                          // i want to come here
                          addToFav(widget.names[widget.index]);
                          // TODO: Add/remove the current location to/from favorites list
                        },
                      ),
                      if (isFavorited)
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the FavoritesPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FavoritesPage(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                          child: Text('View Favorites'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
