import 'package:flutter/material.dart';
import 'package:touristhelper_app/home/user.dart';
import 'package:touristhelper_app/screens/home_screen.dart';
import 'package:touristhelper_app/screens/welcome_screen.dart';

class HomeAppBar extends StatefulWidget {
  final User user;

  const HomeAppBar({super.key, required this.user});
  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  TextEditingController _searchCotrfinaoller = TextEditingController();
  List<String> allContainerNames = [
    "Kuala Lumpur",
    "Terengganu",
    "Sarawak",
    "Kedah",
    "Johor",
    "Sabah",
    "Melaka",
    "Langkawi",
    "Pahang"
  ];
  List<String> displayedContainerNames = [];
// List of container descriptions (corresponding to each container name)
  final List<String> containerDescriptions = [
    'Description for Kuala Lumpur...',
    'Description for Terengganu...',
    'Description for Sarawak...',
    'Description for Kedah...',
    'Description for Johor...',
    'Description for Sabah...',
    'Description for Melaka...',
    'Description for Langkawi...',
    'Description for Pahang...',
  ];
  @override
  void initState() {
    super.initState();
    displayedContainerNames = List.from(allContainerNames);
  }

  void _searchContainers(String query) {
    setState(() {
      displayedContainerNames = allContainerNames
          .where((name) => name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              // Show an alert dialog to confirm logout
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Log Out"),
                    content: Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the alert dialog
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          // Implement logout functionality and navigate to the login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WelcomeScreen(), // Replace with the actual route for the welcome screen
                            ),
                          );
                        },
                        child: Text("Logout"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.logout_rounded,
                size: 28,
              ),
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Color(0xFFF65959),
              ),
              Text(
                "Malaysia",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          InkWell(
            onTap: () {
              // Show a search dialog or navigate to a search screen
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(allContainerNames, widget.user),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6,
                  )
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.search,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final User user;
  final List<String> containerNames;

  CustomSearchDelegate(this.containerNames, this.user);

  final List<String> containerDescriptions = [
    'Kuala Lumpur is the capital and largest city of Malaysia, situated in the western part of Peninsular Malaysia. As a vibrant and cosmopolitan metropolis, Kuala Lumpur serves as the economic, cultural, and financial hub of the country',
    'Terengganu is a state located on the northeastern coast of Peninsular Malaysia. It is known for its rich cultural heritage, beautiful beaches, traditional architecture, and a strong connection to Malaysias Malay traditions. ',
    'Sarawak is the largest state in Malaysia, located on the island of Borneo. Known for its diverse cultures, rich biodiversity, and unique landscapes, Sarawak offers a mix of modern development and traditional charm',
    'Kedah is a state located in the northern part of Peninsular Malaysia. Known as the "Rice Bowl of Malaysia," Kedah is recognized for its agricultural significance, historical heritage, and cultural attractions. ',
    'Johor is a state located at the southern tip of Peninsular Malaysia, sharing a border with Singapore. It is the third-largest state in Malaysia and plays a significant role in the countrys economy and development. ',
    'Sabah is a state situated on the northern part of the island of Borneo, in Malaysia. Known for its diverse landscapes, rich biodiversity, and vibrant cultural heritage, Sabah is a popular destination for nature enthusiasts and adventure seekers.',
    'Melaka, also spelled Malacca, is a historic state and city located on the southwestern coast of Peninsular Malaysia. Known for its rich cultural heritage, colonial history, and diverse influences, Melaka has been recognized as a UNESCO World Heritage Site',
    'Langkawi is an archipelago of 99 islands in the Andaman Sea, about 30 kilometers off the northwestern coast of Peninsular Malaysia. Known as the "Jewel of Kedah," Langkawi is a popular tourist destination.',
    'Pahang is the largest state in Peninsular Malaysia and is known for its diverse landscapes, including mountains, rainforests, and beautiful coastlines. The state offers a range of natural attractions, cultural experiences, and outdoor activities',
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final List<String> results = containerNames
        .where((name) => name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          // Navigate to the detailed screen when a result is tapped
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                  user: user,
                  imagePath:
                      'images/city${(containerNames.indexOf(results[index])+10)}.jpg', // Replace with the actual image path
                  heroTag: 'cityImage$index', // Replace with a unique hero tag
                  names: containerNames,
                  descriptions: containerDescriptions,
                  index: containerNames.indexOf(results[index]),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
