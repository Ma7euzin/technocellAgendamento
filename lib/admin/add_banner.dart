import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddBanner extends StatefulWidget {
  const AddBanner({super.key});

  @override
  State<AddBanner> createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {

  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imagemSelecionada = File(pickedFile.path);
      String imageUrl = await uploadImage(imagemSelecionada);
      _adicionarImagemAoBanner(imageUrl);
    } else {
      // Usuário cancelou a seleção da imagem
    }
  }

  Future<String> uploadImage(File imageFile) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference storageReference =
        storage.ref().child('banner/${DateTime.now().millisecondsSinceEpoch}');
    await storageReference.putFile(imageFile);
    String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }

  void _adicionarImagemAoBanner(String imageUrl) {
    FirebaseFirestore.instance.collection('banners').add({
      'imagemUrl': imageUrl,
    });
  }


  Future<void> _deletarBanner(
      BuildContext context, String docId, String imageUrl) async {
    // Exclui o documento com o ID especificado na coleção "banners"
    await FirebaseFirestore.instance.collection('banners').doc(docId).delete();

    // Exclui a imagem no Firebase Storage
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    await storage.refFromURL(imageUrl).delete();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banners para Usuarios'),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('banners').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Nenhuma imagem encontrada.'));
            } else {
              return Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.grey),
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var imageUrl = snapshot.data!.docs[index]['imagemUrl'];
                    var docId = snapshot.data!.docs[index].id;
                    return Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: ListTile(
                            leading: Image.network(imageUrl),
                            title: Text('Banner $index'),
                            trailing: snapshot.data!.docs.length == 1
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Confirmar exclusão'),
                                            content: const Text(
                                                'Tem certeza que deseja excluir este Banner?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _deletarBanner(
                                                      context, docId, imageUrl);
                                                   Navigator.of(context).pop();  
                                                },
                                                child: const Text('Excluir'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selecionarImagem,
        child: const Icon(Icons.add),
      ),
    );
  }
}