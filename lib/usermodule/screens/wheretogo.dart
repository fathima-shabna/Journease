import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WhereToGo extends StatefulWidget {
  WhereToGo({super.key});

  @override
  State<WhereToGo> createState() => _WhereToGoState();
}

class _WhereToGoState extends State<WhereToGo> {
  final _searchController = TextEditingController();
  String? states; 
  final PageController pageController = PageController();

    final List<String> imageUrls = [
    "https://www.india.com/wp-content/uploads/2019/02/Vagamon.jpg",
    "https://t4.ftcdn.net/jpg/02/57/04/75/360_F_257047502_rsTFhzpEK7okzIBHiMTZwRZ6Ihlzc68K.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYAFzgPq7V7Vb8HVWoWKnXWnzPiLpfEHfpi21lutMBrI07BaqLW5L7QRtRmv_XcyTMoeU&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpgtjA6QcNmUW8-cEJj5ecxUeDzK7ARaUnZ0j0TI-HaVUYHs97GYoVb774SfjiQVeSBm4&usqp=CAU"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        title: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.60,
              // child: TextFormField(
                
              //   style: TextStyle(fontSize: 16),
              //   cursorHeight: 18,
              //   showCursor: false,
              //   controller: _searchController,
              //   decoration: const InputDecoration(
              //       labelText: "Search places",
              //       labelStyle: TextStyle(
              //       fontSize: 14,
              //       ),
              //       isCollapsed: true,
              //       contentPadding: EdgeInsets.all(10),
              //       focusedBorder: OutlineInputBorder(),
              //       border: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Colors.black12,
              //         ),
              //       )),
              // ),

              
                     child:     DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              isCollapsed: true,
                        contentPadding: EdgeInsets.all(12),
                        labelStyle: TextStyle(fontSize: 12),
                              labelText: 'Search place',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
                            ),
                            value: states,
                            items: ["Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand", "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"]
                                .map((states) => DropdownMenuItem(
                                      value: states,
                                      child: Text(states),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() => states = value),
                          ),
                        
            ),
            SizedBox(
                child: IconButton(onPressed: () {}, icon: Icon(Icons.search)))
          ],
        ),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
            // border: Border.all(color: Colors.black54),
            color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Vagamon",style: TextStyle(fontWeight: FontWeight.w700),),
                          Text("Kerala's paragliding paradise",style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Icon(Icons.favorite_outline_sharp)
                    ],
                  ),
                  SizedBox(height: 15,),
                  Container(
              height: 130,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                PageView.builder(itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(imageUrls[index],fit: BoxFit.fill,),
                ),itemCount: imageUrls.length,
                controller: pageController,
                ),
                Positioned(
                  bottom: -12,
                  left: 0,
                  right: 0,
                  child: Center(child: SmoothPageIndicator(controller: pageController, count: imageUrls.length,
                  effect: WormEffect(
                          dotHeight: 5,
                          dotWidth: 5,
                          activeDotColor: Colors.amber,
                          dotColor: Colors.grey,
                        ),)))
              ],),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                 ),       
            ),
            SizedBox(height: 20,),
            Text("What to expect",style: TextStyle(fontWeight: FontWeight.w700),),
            SizedBox(height: 20,),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
              color: Colors.blue[100]),
              child: Text("Explore Vagamon",textAlign: TextAlign.center,),
            )
                ],
              ),
            ),
          ),
        );
      },itemCount: 5,)
    );
  }
}
