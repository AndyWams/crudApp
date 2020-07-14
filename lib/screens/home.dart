import 'package:crudApp/model/user_model.dart';
import 'package:crudApp/util/repository.dart';
import 'package:flutter/material.dart';
import 'add_record.dart';
import './add_record.dart';
import 'package:crudApp/main.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseHelper _dbHelper;
  List<Contact> _contacts = [];
  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
    _refreshContactList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(
            'Flutter CrudApp',
            style: TextStyle(color: Colors.blue[200]),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => _refreshContactList(),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: _list(),
                    ),
                  ),
                ),
              ])),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => NewRecord()));
          },
          tooltip: 'Add New',
          child: const Icon(Icons.add),
        ));
  }

  _list() => FutureBuilder(
      future: _fetchAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: Scrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                          leading: Icon(
                            Icons.account_circle,
                            color: Colors.black,
                            size: 40.0,
                          ),
                          title: Text(
                            snapshot.data[index].name.toUpperCase(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(snapshot.data[index].title),
                          onTap: () async {
                            await _onUserTap(context, snapshot.data[index].id);
                          },
                          trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.black),
                              onPressed: () async {
                                await _dbHelper
                                    .deleteContact(snapshot.data[index].id);
                                _refreshContactList();
                              })),
                      Divider(
                        height: 5.0,
                      ),
                    ],
                  );
                },
              ),
            ),
            // child: Card(
            //   margin: EdgeInsets.fromLTRB(20, 30, 20, 10),
            //   child: ,
            // ),
          );
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      });

  _refreshContactList() async {
    List<Contact> x = await _dbHelper.fetchContacts();
    setState(() {
      _contacts = x;
    });
  }

  _fetchAll() async {
    return await _dbHelper.fetchContacts();
  }

  _onUserTap(BuildContext context, int userId) {
    Navigator.pushNamed(context, EditRecord, arguments: userId);
  }
}
