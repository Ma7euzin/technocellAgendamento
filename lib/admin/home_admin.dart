import 'package:appdouglas/admin/abrir_agendamento.dart';
import 'package:appdouglas/admin/add_banner.dart';
import 'package:appdouglas/widget/widget_support.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            Center(
              child: Text(
                'Home Admin',
                style: AppWidget.HeadLineTextFeildStyle(),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(10),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddBanner(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Banners para Usuarios',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OpenAgend(),
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
                  'CRIAR AGENDA',
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
