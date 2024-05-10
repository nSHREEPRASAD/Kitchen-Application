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
  ];
  @override
  Widget build(BuildContext context) {
    var ScreenH = MediaQuery.of(context).size.height;
    var ScreenW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ghadi's Kitchen"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: (ScreenH*250)/672,
              width: double.infinity,
              child: CarouselSlider.builder(
                itemCount: 4,
                itemBuilder: (context,index,realIndex){
                  return Container(
                    width: double.infinity,
                    child: Image.network(urlImg[index]),
                  );
                }, 
                options: CarouselOptions(
                  height: (ScreenH*400)/672,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  enlargeCenterPage: true,
                )),
            ),
            SizedBox(height: (ScreenH*20)/672,),
            Container(
              width: (ScreenW*320)/360,
              height: (ScreenH*300)/672,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ghadi's Kitchen: A Tradition of Authentic Maharashtrian Cuisine",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    SizedBox(height: (ScreenH*20)/672,),
                    Text("Established in the 1980s by Mr. Vijay Ghadi in Mumbai, Ghadi's Kitchen has grown into a family-run restaurant group with branches across Mumbai, Thane, and Pune. We specialize in traditional Maharashtrian cuisine, offering a variety of dishes that cater to all palates.",style: TextStyle(fontSize: 20),),
                    SizedBox(height: (ScreenH*20)/672,),
                    Text("Our Menu:",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
                    SizedBox(height: (ScreenH*15)/672,),
                    Text("Breakfast Delights:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    Text("We start your day right with a selection of classic Maharashtrian breakfast dishes like Upma, Pohe, Idli-Sambar, and Dosas.",style: TextStyle(fontSize: 20),),
                    SizedBox(height: (ScreenH*10)/672,),
                    Text("Lunch and Dinner Thalis:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    Text("Enjoy a complete and satisfying meal with our daily specials. Our Thalis include a variety of Bhajis (vegetable fritters), Chapati (flatbreads), Dal (lentil soup), Rice, and a sweet ending with Dessert.",style: TextStyle(fontSize: 20),),
                    SizedBox(height: (ScreenH*10)/672,),
                    Text("Authentic Flavors:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    Text("We use only the freshest ingredients and traditional recipes to create authentic Maharashtrian dishes that are both delicious and comforting.",style: TextStyle(fontSize: 20),),
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