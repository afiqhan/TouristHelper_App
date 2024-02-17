import 'package:flutter/material.dart';
import 'package:touristhelper_app/home/user.dart';
import 'package:touristhelper_app/home_bottom_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritesPage extends StatefulWidget {
  final User user;

  FavoritesPage({Key? key, required this.user}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // Assume these are the names of favorited locations
  List<dynamic> favList = [];
  List<String> favListKeys = [];

  void deleteFromFavFirebase(String firebasekey, int index) async {   //deleted will also successful if connect to firebase
    final url = Uri.https(firebaseUrl, "fav/$firebasekey.json");
    try {
      final response = await http.delete(url);  
      if (response.statusCode == 200) { 
        favList.removeAt(index);
        ScaffoldMessenger.of(context)  
            .showSnackBar(SnackBar(content: Text("Place Deleted 👍🏻")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Could not delete 👎🏻")));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $error")));
      print("Favourites.dart => error: $error");
    }
  }

  void getFavPlace() async {
    final url = Uri.https(firebaseUrl, "fav.json");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        print(data);
        List<dynamic> tempList = [];
        List<String> tempListKeys = [];
        data.entries.forEach((element) {
          tempList.add(element.value["placeName"]);
          tempListKeys.add(element.key);
        });

        setState(() {
          favList = tempList;
          favListKeys = tempListKeys;
        });
      }
    } catch (error) {
      print("error $error");
    }
  }

  @override
  void initState() {
    getFavPlace();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
        ),
        bottomNavigationBar: HomeBottomBar(
          user: widget.user,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('images/user.jpg'), 
              fit: BoxFit.cover,
            ),
          ),
          child: favList.isEmpty
              ? Center(
                  child: Text('No favorites yet.'),
                )
              : ListView.builder(
                  itemCount: favList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.redAccent),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          deleteFromFavFirebase(favListKeys[index], index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(favList[index]),
                            // Add more details if needed
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ));
  }
}
