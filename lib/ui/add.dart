import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/sql/completed.dart';


class Add extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return AddState();
  }

}

class AddState extends State<Add>{
  
  final _formkey = GlobalKey<FormState>();
  final myController = TextEditingController();
  TodoProvider todo = TodoProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Subject"),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          children: <Widget>[

            Container(
              child: new TextFormField(
                decoration: InputDecoration(
                //contentPadding: const EdgeInsets.all(10.0),
                labelText: "Subject",
                ),
                controller: myController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill subject";
                  }
                }
              ),
              margin: new EdgeInsets.only(
                left:10.0, right: 10.0,
              ),
            ),
            
            Container(
              child: new RaisedButton(
                child: Text("Save"), padding: const EdgeInsets.all(10.0),
                onPressed: () async {
                  _formkey.currentState.validate();
                  if(myController.text.length > 0){
                    await todo.open("todo.db");
                    Todo data = Todo();
                    data.todoItem = myController.text;
                    data.isDone = false;
                    await todo.insert(data);
                    print(data);
                    print('insert complete');
                    Navigator.pop(context);
                  }
                  myController.text = "";
                },
              ),
              margin: new EdgeInsets.only(
                  left:10.0, right: 10.0,
                ),
            ),

          ],
        ),
      ),
    );
  }

}