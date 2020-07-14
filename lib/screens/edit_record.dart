import 'package:crudApp/model/user_model.dart';
import 'package:crudApp/util/repository.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class UpdateRecord extends StatefulWidget {
  @override
  _State createState() => _State();

  final int userId;

  UpdateRecord(this.userId);
}

class _State extends State<UpdateRecord> {
  final _formKey = GlobalKey<FormState>();
  final Contact _contact = Contact();
  final _ctrlName = TextEditingController();
  final _ctrlTitle = TextEditingController();
  final _ctrlId = TextEditingController();
  // List<Contact> _contacts;
  DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
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
          'Update Record',
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
    return FutureBuilder(
        future: _getId(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _ctrlName.text = snapshot.data.name;
            _ctrlTitle.text = snapshot.data.title;
            _ctrlId.text = snapshot.data.id.toString();
            return Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        controller: _ctrlName,
                        decoration: InputDecoration(labelText: 'Fullname'),
                        validator: (val) => (val.length == 0
                            ? 'This field must not be empty'
                            : null),
                        onSaved: (val) => _ctrlName.text = val),
                    TextFormField(
                        controller: _ctrlTitle,
                        decoration: InputDecoration(labelText: 'Title'),
                        validator: (val) => (val.length == 0
                            ? 'This field must not be empty'
                            : null),
                        onSaved: (val) => _ctrlTitle.text = val),
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
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }

  _getId() async {
    return await _dbHelper.getContact(widget.userId);
  }

  _onSubmit(context) async {
    var form = _formKey.currentState;
    _contact.id = int.parse(_ctrlId.text);
    _contact.name = _ctrlName.text;
    _contact.title = _ctrlTitle.text;
    if (form.validate()) {
      await _dbHelper.updateContact(_contact);
      _resetForm();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Home()));
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _ctrlName.clear();
      _ctrlTitle.clear();
    });
  }
}
