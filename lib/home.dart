import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_recipe/models.dart';
import 'package:food_recipe/recipeview.dart';
import 'package:food_recipe/search.dart';
import 'package:http/http.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchController = TextEditingController();

  getRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=12e5ebaa&app_key=8ce31255c0ee1d9252092a53fd363b48";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    data["hits"].forEach((element) {
      RecipeModel recipeModel = RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipeList.add(recipeModel);
      setState(() {
        isLoading = false;
      });
      // log(recipeList.toString());
    });
    recipeList.forEach((Recipe) {
      // print(Recipe.applabel);
      // print(Recipe.appcalories);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe("rajma chawal");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0xff213A50),
      //   title: Center(
      //     child: Text(
      //       "Food Recipe App",
      //       style: TextStyle(fontWeight: FontWeight.bold),
      //     ),
      //   ),
      // ),
      body: Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff213A50), Color(0xff071938)])),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((searchController.text).replaceAll(" ", "") ==
                                "") {
                              print("Blank search");
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Search(searchController.text)));
                            }
                          },
                          child: Container(
                            child: Icon(
                              Icons.search,
                              color: Colors.blueAccent,
                            ),
                            margin: EdgeInsets.fromLTRB(5, 0, 7, 0),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                          controller: searchController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Let's Cook Something!"),
                        ))
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "WHAT DO YOU WANT TO COOK TODAY?",
                        style: TextStyle(fontSize: 33, color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Let's Cook Something New!",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )
                    ],
                  ),
                ),
                Container(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: recipeList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecipeView(
                                            recipeList[index].appurl)));
                              }),
                              child: Card(
                                  margin: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  elevation: 0.0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                            recipeList[index].appimgUrl,
                                            fit: BoxFit.cover,
                                            height: 180,
                                            width: double.infinity),
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.black26),
                                              child: Text(
                                                recipeList[index].applabel,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ))),
                                      Positioned(
                                          right: 0,
                                          height: 35,
                                          width: 90,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10)),
                                                color: Colors.white),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .local_fire_department,
                                                      size: 16),
                                                  Text(
                                                    recipeList[index]
                                                        .appcalories
                                                        .toString()
                                                        .substring(0, 6),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                    ],
                                  )),
                            );
                          }),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
