import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/sql/completed.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  
  int _done = 0;
  static TodoProvider todo = TodoProvider();
  List<Todo> task = [];
  List<Todo> completed = [];

  @override
  Widget build(BuildContext context) {

    final List _button = <Widget>[
      IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
            Navigator.pushNamed(context, "/add");
            },
          ),
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async{
            for(var item in completed){
              print(item.id);
              await todo.delete(item.id);
            }
            setState(() {
              completed = [];
            });
            },
          ),
    ];

    return DefaultTabController(
      length: 2,
      initialIndex: _done,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[
            _done == 0 ? _button[0] : _button[1]
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _done,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.format_list_bulleted),
              title: Text("Task"),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.done_all),
              title: Text("Completed"),
            ),
          ],
          onTap: (index){
            setState(() {
              _done = index;
            });
            print(_done);
          }
        ),
        body: _done == 0 ?

        //state = 1 
        Container(
          child: FutureBuilder<List<Todo>>(
            future: todo.getAll(),
            builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
              task = [];
              if (snapshot.hasData){
                for (var items in snapshot.data) {
                  if (items.isDone == false) {
                    task.add(items);
                  }
                }
                //data available
                return task.length != 0 ? 
                  ListView.builder(
                    itemCount: task.length,
                    itemBuilder: (BuildContext context, int index) {
                      Todo item = task[index];
                      return ListTile(
                        title: Text(item.todoItem),
                        trailing: Checkbox(
                        onChanged: (bool value) async {
                          setState(() {
                            item.isDone = value;
                          });
                          todo.update(item);
                          },
                        value: item.isDone,
                        ),
                      );
                    },
                  )
                  //unavailable
                  : Center(
                    child: Text("No data found.."),
                  );

              } else {
                return Center(
                  child: Text("No data found.."),
                );
              }
            }
          ),
        )
        :
        Container(
          child: FutureBuilder<List<Todo>>(
            future: todo.getAll(),
            builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
              completed = [];
              if (snapshot.hasData){
                for (var items in snapshot.data) {
                  if (items.isDone == true) {
                    completed.add(items);
                  }
                }

                return completed.length != 0 ? 
                  ListView.builder(
                    itemCount: completed.length,
                    itemBuilder: (BuildContext context, int index) {
                      Todo item = completed[index];
                      return ListTile(
                        title: Text(item.todoItem),
                        trailing: Checkbox(
                        onChanged: (bool value) async {
                          setState(() {
                            item.isDone = value;
                          });
                          todo.update(item);
                          },
                        value: item.isDone,
                        ),
                      );
                    },
                  )
                  : Center(
                    child: Text("No data found.."),
                  );

              } else {
                return Center(
                  child: Text("No data found.."),
                );
              }
            }
          ),
        )
        ),  
    );
  }

}