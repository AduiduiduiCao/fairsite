import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'company_info.dart';

class DeleteAssets extends StatefulWidget {
  @override

  final String entityId;

  DeleteAssets(this.entityId);

  State<StatefulWidget> createState() {
    return _SelectedValueState(entityId);
  }
}

class _SelectedValueState extends State<DeleteAssets> {
  var _currentAssetTitle;

  final String _entityId;

  _SelectedValueState(this._entityId);

  var _formData = {"asset_type": "", "asset_id": ""};

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            clipBehavior: Clip.none,
            child: Container(
                padding: EdgeInsets.all(5), child: const Text("Delete Asset")),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                        contentPadding: EdgeInsets.all(20),
                        children: [
                          Form(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: "Asset type: ",
                                    contentPadding: EdgeInsets.all(20)),
                                items: AssetType.values.map((item) {
                                  return DropdownMenuItem(
                                      value: item.name, child: Text(item.name));
                                }).toList(),
                                onSaved: (current) {
                                  this._currentAssetTitle = current.toString();
                                },
                                onChanged: (current) async {
                                  setState(() {
                                    this._currentAssetTitle =
                                        current.toString();
                                    this._formData["asset_type"] =
                                        current.toString();
                                  });
                                },
                                value: this._currentAssetTitle,
                              ),
                              TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Asset ID:",
                                      contentPadding: EdgeInsets.all(20)),
                                  onChanged: ((value) {
                                    setState(() {
                                      this._formData["asset_id"] = value.trim();
                                    });
                                  })),
                              ElevatedButton(
                                    onPressed: () async {
                                  // Code to handle deleting the asset
                                  await FirebaseFirestore.instance
                                      .collection('company')
                                      .doc(_entityId)
                                      .collection('asset')
                                      .where('id', isEqualTo: _formData['asset_id'])
                                      .get()
                                      .then((querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      doc.reference.delete();
                                    });
                                  });
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.all(20),
                                ),
                                child: const Text('Delete Asset'),
                              ),
                            ],
                          ))
                        ]);
                  });
            }));
  }
}