import 'package:appdouglas/pages/agendamento_page.dart';
import 'package:appdouglas/services/shared_pref.dart';
import 'package:appdouglas/widget/widget_support.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  onthisload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onthisload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(
          top: 60.0,
          left: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Olá $name",
                  style: AppWidget.boldTextFeildStyle(),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(2),
                    ),
                  ),
                  /*child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),*/
                ),
              ],
            ),

            const SizedBox(
              height: 20.0,
            ),
            // banner que o admin adicionar
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('banners').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    List<String> bannersUrls = snapshot.data!.docs
                        .map((doc) => doc['imagemUrl'] as String)
                        .toList();
                    // Verifica se há mais de uma imagem
                    if (bannersUrls.length > 1) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CarouselSlider(
                          items: bannersUrls.map((imageUrl) {
                            return Image.network(imageUrl);
                          }).toList(),
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            enlargeCenterPage: true,
                          ),
                        ),
                      );
                    } else {
                      // Se houver apenas uma imagem, não inicia o autoPlay
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(bannersUrls.first),
                      );
                    }
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/BannerTC.png'),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              "TECHNOCELL",
              style: AppWidget.HeadLineTextFeildStyle(),
            ),
            Text(
              "Serviços de qualidade",
              style: AppWidget.HeadLineTextFeildStyle(),
            ),
            Text(
              "Descubra e obtenha uma ótima Experiêcia",
              style: AppWidget.LightTextFeildStyle(),
            ),
            const SizedBox(
              height: 20,
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AgendPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Cor de fundo
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20), // Ajusta o tamanho do botão
                ),
                child: const Text(
                  'AGENDAR DIA',
                  style: TextStyle(
                    color: Colors.white, // Cor do texto
                    fontWeight: FontWeight.bold, // Negrito
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
