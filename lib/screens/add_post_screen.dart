import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pulse_social/resources/firetore_methods.dart';
import 'package:pulse_social/utils/colors.dart';
import 'package:pulse_social/utils/utils.dart';
import 'package:pulse_social/models/user.dart';
import 'package:pulse_social/providers/user_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
  }

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  void postImage(
      String uid,
      String username,
      String profImage,
      )async{
    setState(() {
      _isLoading = true;
    });
        try{
          String res = await FirestoreMethods().uploadPost(
              _descriptionController.text,
              _file!,
              uid,
              username,
              profImage,
          );
          if(res=="Success"){
            setState(() {
              _isLoading = false;
            });
            showSnackBar('Posted!', context);
            clearImage();
          }else{
            setState(() {
              _isLoading = false;
            });
            showSnackBar(res, context);
          }
        }
        catch(e){
          showSnackBar(e.toString(), context);
        }
  }

  _selectImage(BuildContext context)async{
    return showDialog(context: context, builder:(context){
      return SimpleDialog(
        title : const Text('create a post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Take a Photo'),
            onPressed: ()async{
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Choose from Gallery'),
            onPressed: ()async{
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Cancel'),
            onPressed: (){
              Navigator.of(context).pop();
            }
          ),
        ],
      );
    });
  }
  void clearImage(){
    setState(() {
      _file = null;
    });
  }

@override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
     return _file==null? Center(
        child: IconButton(
          icon: const Icon(Icons.upload),
          onPressed: () => _selectImage(context),
        ),
      )
     :Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:clearImage,
        ),
        title: const Text('Post to'),
        centerTitle: false,
        actions: [
          TextButton(onPressed:()=>postImage(
                       user.uid,
                       user.username,
                       user.photoUrl,
          ),
              child: const Text(
            'post',
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ))
        ],
      ),
      body:Column(
        children: [
          _isLoading? const LinearProgressIndicator() :const Padding(padding:EdgeInsets.only(top: 0),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.3,
                child:TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                  hintText:'Write a caption...' ,
                  border: InputBorder.none,
                  ),
                ) ,
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],
          )
        ],
      ) ,
    );
  }
}
