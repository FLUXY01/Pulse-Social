import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pulse_social/utils/colors.dart';
import 'package:pulse_social/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Image(image: AssetImage("assets/pulse_social_feed.png"), height: 35,),
               actions: [
                 IconButton(onPressed: (){},
                   icon: const Icon(
                        Icons.messenger_outline),),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder:(context,index)=>PostCard(
              snap: snapshot.data!.docs[index].data()
            ),
          );
        }
      ),
    );
  }
}
