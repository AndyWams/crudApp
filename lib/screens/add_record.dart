import 'package:crudApp/model/user_model.dart';
import 'package:crudApp/util/repository.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class NewRecord extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<NewRecord> {
  List<Contact> _contacts = [];
  final _formKey = GlobalKey<FormState>();
  final Contact _contact = Contact();
  DatabaseHelper _dbHelper;
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
    _refreshContactList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'New Record',
          style: TextStyle(color: Colors.blue[200]),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: _form(context),
      ),
    );
  }

  Widget _form(context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
                decoration: InputDecoration(labelText: 'Fullname'),
                validator: (val) =>
                    (val.length == 0 ? 'This field must not be empty' : null),
                onSaved: (val) => _contact.name = val),
            TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (val) =>
                    (val.length == 0 ? 'This field must not be empty' : null),
                onSaved: (val) => _contact.title = val),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: RaisedButton(
                onPressed: () => _onSubmit(context),
                child: Text('Submit'),
                color: Colors.blue,
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _onSubmit(context) async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      await _dbHelper.insertContact(_contact);
      form.reset();
      await _refreshContactList();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Home()));
    }
  }

  _refreshContactList() async {
    List<Contact> x = await _dbHelper.fetchContacts();
    setState(() {
      _contacts = x;
    });
  }
}
