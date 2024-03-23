import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class KitchenIntro extends StatefulWidget {
  const KitchenIntro({super.key});

  @override
  State<KitchenIntro> createState() => _KitchenIntroState();
}

class _KitchenIntroState extends State<KitchenIntro> {
  final urlImg=[
    "https://sulcdn.azureedge.net/biz-live/img/ghadi-s-tiffin-service-11015049-cff57569.jpeg",
    "https://content.jdmagicbox.com/comp/mumbai/u9/022pxx22.xx22.210114072516.i2u9/catalogue/ghadi-s-tiffin-service-mulund-east-mumbai-tiffin-services-qkdq6028vx.jpg",
    "https://cascade.madmimi.com/promotion_images/1602/1370/original/Everyday_Meal_Plate_Baby_Corn_Thoran_Arbi_Pulusu_Pottu_Kadalai_Curry-1.jpg?1488787731",
    "https://www.mishry.com/wp-content/uploads/2020/04/oats-idli.jpg",
    "https://dipsdiner.com/dd/wp-content/uploads/2015/04/Maharashrian-Recipes-for-breakfast-Kande-Pohe.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ghadi's Kitchen"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: CarouselSlider.builder(
                itemCount: 5,
                itemBuilder: (context,index,realIndex){
                  return Container(
                    width: double.infinity,
                    child: Image.network(urlImg[index]),
                  );
                }, 
                options: CarouselOptions(
                  height: 300,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  enlargeCenterPage: true,
                )),
            ),
            SizedBox(height: 20,),
            Container(
              child: Row(
                children: [
                  SizedBox(width: 20,),
                  Text("Owner :- Amogh Ghadi",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 30,color: Colors.black87,fontWeight: FontWeight.bold),),
                ],
              )
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(width: 20,),
                Container(
                  child: Text("About Kitchen :-",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
                ),
              ],
            ),
            SizedBox(height: 10,),
            Container(
              width: 320,
              height: 190,
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.black
              //   ),
              //   borderRadius: BorderRadius.circular(15),
              // ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("Ghadi's Kitchen was established",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("in 1980's. It was started by my ",style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("father Mr Vijay Ghadi in Mumbai. ",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("Today, we have branches at diff- ",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("erent places in Mumbai, Thane & ",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("Pune.",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("We have different dishes, such ",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("as Upma, Pohe, Idli-Sambar &",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("dosas. We also have Chapatis.",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("& different types of Bhajis",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("We also have a daily meal thali",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("consisting various special items",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("such as chapati, bhaji, dal, rice ",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("& desert.",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("Thank you !",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            child: Text("Amogh Ghadi.",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}