

import 'package:flutter/material.dart';
import 'package:touristhelper_app/home/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPlacePage extends StatefulWidget {
  @override
  _RegisterPlacePageState createState() => _RegisterPlacePageState();
}


class _RegisterPlacePageState extends State<RegisterPlacePage>
    with TickerProviderStateMixin {
  // Create an instance of PlaceDatabase
  final PlaceDatabase placeDatabase = PlaceDatabase();

  List<dynamic> myList =[];

  // Controller for the text field
  final TextEditingController _placeNameController = TextEditingController();

  // Controller for the text field used for updating place name
  final TextEditingController _updatePlaceNameController =
      TextEditingController();

  // Index of the place to be updated
  int? updateIndex;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
 void getRegisterPlace()async{
    final url = Uri.https(firebaseUrl, "registerPlaces.json");


    try{
final response = await http.get(url);
        if(response.statusCode == 200){
          Map<String, dynamic> data = json.decode(response.body);
          print(data);
          List<dynamic> tempList = [];
          data.entries.forEach((element) {
             tempList.add(element.value["placeName"]);
          });

          setState(() {
            myList = tempList;
          });
        }
    }catch(error){
      print("error $error");
    }
  }  
  
  @override
  void initState() {
    super.initState();
    getRegisterPlace();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, 
      ), 
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the list of registered places
    List<String> registeredPlaces = placeDatabase.getAllRegisteredPlaces();

    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Places'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/user.jpg'), 
            fit: BoxFit.cover,
          ),
       ), 
      child : Center(
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text field for entering a new place name
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _placeNameController,
                decoration: InputDecoration(
                  hintText: 'Enter place name',
                ),
              ),
            ),
            // Button to register a new place
            ScaleTransition(
              scale: _scaleAnimation,
              child: ElevatedButton(
                onPressed: () {
                  // Register a new place
                  String newPlaceName = _placeNameController.text;
                  placeDatabase.registerPlace(newPlaceName);

                  // Clear the text field
                  _placeNameController.clear();

                  // Update the UI to reflect the new registered places
                  setState(() {});
                },
                child: Text('Register Now'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            // Display the list of registered places
            myList.isEmpty
                ? Text('No places registered yet.')
                : Expanded(
                    child: ListView.builder(
                      itemCount: myList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(myList[index]),
                          // You can customize the ListTile as needed
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Set the index and text field for updating
                                  setState(() {
                                    updateIndex = index;
                                    _updatePlaceNameController.text =
                                        myList[index];
                                  });

                                  // Show the update place name dialog
                                  _showUpdateDialog();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Delete the place
                                  placeDatabase
                                      .unregisterPlace(registeredPlaces[index]);

                                  // Update the UI to reflect the changes
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),),
      backgroundColor: const Color.fromARGB(255, 114, 123, 177),
    );
  }

  // Function to show the update place name dialog
  Future<void> _showUpdateDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Place Name'),
          content: TextField(
            controller: _updatePlaceNameController,
            decoration: InputDecoration(
              hintText: 'Enter updated place name',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Update the place name
                String updatedPlaceName = _updatePlaceNameController.text;
                placeDatabase.updatePlaceName(
                    placeDatabase.getAllRegisteredPlaces()[updateIndex!],
                    updatedPlaceName);

                // Clear the text field and reset the updateIndex
                _updatePlaceNameController.clear();
                setState(() {
                  updateIndex = null;
                });

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class PlaceDatabase {
  // A list to simulate a database
  List<String> registeredPlaces = [];

  // Create: Method to register a place
  void registerPlace(String placeName) {
    registeredPlaces.add(placeName);
  }

  // Read: Method to get all registered places
  List<String> getAllRegisteredPlaces() {
    return List.from(registeredPlaces);
  }

  // Update: Method to update the name of a registered place
  void updatePlaceName(String oldName, String newName) {
    int index = registeredPlaces.indexOf(oldName);
    if (index != -1) {
      registeredPlaces[index] = newName;
    }
  }

  // Delete: Method to unregister a place
  void unregisterPlace(String placeName) {
    registeredPlaces.remove(placeName);
  }
}
