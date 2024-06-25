import 'package:flutter/material.dart';
import 'package:hookup4u_admin/constants/constants.dart';

class CreatePackage extends StatefulWidget {
  final Map index;
  final List<Map<String, dynamic>> productList;
  const CreatePackage(this.index, this.productList, {super.key});

  @override
  CreatePackageState createState() => CreatePackageState();
}

class CreatePackageState extends State<CreatePackage> {
  @override
  void initState() {
    if (widget.index.isNotEmpty) {
      activates = widget.index['status'] ?? false;
      edit = true;
      idctlr.text = widget.index['id'] ?? "";
      titlectlr.text = widget.index['title'] ?? "";
      descctlr.text = widget.index['description'] ?? "";
    }
    if (mounted) setState(() {});
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> data = {};

  TextEditingController idctlr = TextEditingController();

  TextEditingController titlectlr = TextEditingController();

  TextEditingController descctlr = TextEditingController();

  bool edit = false;
  bool activates = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                edit ? "Edit subscription" : "Add new subscription",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context, null))),
          Positioned(
              bottom: 22,
              right: 20,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                  ),
                  child: Text(
                    edit ? "Save Changes" : "SAVE",
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      data['status'] = activates;
                      Navigator.pop(context, data);
                    }
                  })),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 25, right: 100),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ListTile(
                dense: true,
                leading: Checkbox(
                    value: activates,
                    tristate: true,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (val) {
                      setState(() {
                        activates = !activates;
                        // widget.index["status"] = !widget.index["status"];
                      });
                    }),
                title: const Text("Activate"),
              ),
            ),
          ),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: titlectlr,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                          helperText: "this is how it will appear in app",
                          labelText: "Title",
                          hintText: "Title",
                          floatingLabelStyle: TextStyle(color: primaryColor),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          focusColor: primaryColor),
                      onSaved: (value) {
                        data['title'] = value;
                      },
                    ),
                    TextFormField(
                      controller: idctlr,
                      readOnly: edit,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter id';
                        } else if (data['id'] != null &&
                            widget.productList
                                .any((element) => element['id'] == value)) {
                          return 'id already exist ';
                        }
                        return null;
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                          helperText:
                              "it should match with play console product id",
                          labelText: "Product id",
                          hintText: "Product id",
                          floatingLabelStyle: TextStyle(color: primaryColor),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          focusColor: primaryColor),
                      onChanged: (value) {
                        data['id'] = value;
                      },
                    ),
                    TextFormField(
                      controller: descctlr,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                      minLines: 1,
                      autofocus: false,
                      cursorColor: Theme.of(context).primaryColor,
                      maxLines: 5,
                      decoration: InputDecoration(
                          helperText: "this is how it will appear in app",
                          labelText: "Description",
                          hintText: "Description",
                          floatingLabelStyle: TextStyle(color: primaryColor),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          focusColor: primaryColor),
                      onSaved: (value) {
                        data['description'] = value;
                      },
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
