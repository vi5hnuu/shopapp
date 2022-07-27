import 'package:flutter/material.dart';

Future showCustomDialog({required BuildContext context,required String title}){
 return showDialog(//not attacched to ScaffoldMess... as it can be shown anywhere
//showDialog return Future<T>
      context: context,
      builder: (BuildContext ctx){
        return AlertDialog(
          title: Text(
            'Are You Sure ?',
            style: TextStyle(
                fontSize: 24,
                fontFamily: 'RobotoCondensed'
            ),
          ),
          content: Text(
            'This action will permanently delete the ${title} item',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(onPressed: (){
              Navigator.pop(context,true);
            }, icon: Icon(Icons.check_circle_outline)),
            IconButton(onPressed: (){
              Navigator.pop(context,false);
            }, icon: Icon(Icons.cancel_outlined))
          ],
        );
      }
  );
}