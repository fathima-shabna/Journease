import 'package:flutter/material.dart';

class Support extends StatelessWidget {
  const Support({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_rounded,size: 18,)),
        title: Text("Support",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            Text("Need help?",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
            SizedBox(height: 10,),
            TextFormField(
                  minLines: 5,
                  maxLines: 7,
                  decoration: InputDecoration(
                    
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12),
                    labelStyle: TextStyle(fontSize: 12),
                    labelText: 'Type here...',
                    border: OutlineInputBorder(),
                    
                  ),
                ),
                SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 222, 121, 90),),
                  onPressed: () {
                    
                    // Save co-traveller
                  },
                  child: Text('Submit',style: TextStyle(color: Colors.white),),
                ),
              ),
          ],
        ),
      ),
    );
  }
}