
import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createFolder({
    required String name,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final ref = _storage.ref();
    Reference? _folderRef = await ref.child('users/${user.uid}/$name/first_file.txt');
    if (_folderRef == null) {
      throw Exception('Folder not created');

    }
    _folderRef.putString('This is the first file of the folder');
    }

  Future<UploadTask?> uploadFile(XFile? file) async {
    if (file == null) {
     /* ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );*/
      throw Exception('No file was selected');

      return null;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('flutter-tests')
        .child('/some-image.jpg');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(File(file.path), metadata);
    }

    return Future.value(uploadTask);
  }

  // fonction that return a stream of the status for the current uploading


  // get all folders
  Future<List<Reference>> getFolders(String? specificPath) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }
    final ref = _storage.ref();
    ListResult result = await ref.child(
      specificPath == null ? 'users/${user.uid}/' : 'users/${user.uid}/$specificPath/',
    ).listAll();
    print(result.items);
    return result.prefixes;
  }

  Future<List<Reference>> getFiles(String? specificPath) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }
    final ref = _storage.ref();
    ListResult result = await ref.child(
      specificPath == null ? 'users/${user.uid}/' : 'users/${user.uid}/$specificPath/',
    ).listAll();
    print(result.items);
    return result.items;
  }

  Future<String> getDownloadUrl(String targetPath, String fileName) async{
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }
    final ref = _storage.ref();
    String downloadUrl = await ref.child('users/${user.uid}/$targetPath/$fileName').getDownloadURL();
    return downloadUrl;

  }




}