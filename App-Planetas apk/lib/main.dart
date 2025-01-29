// ignore_for_file: non_constant_identifier_names



// Importação de pacotes necessários, incluindo Flutter, a tela de detalhes do planeta, o controle para manipulação de planetas e o modelo Planeta.
import 'package:flutter/material.dart';
import 'package:myapp/telas/tela_planeta.dart';
import 'controles/controle_planeta.dart';
import 'modelos/planeta.dart';


// Função principal que inicializa o aplicativo chamando o widget MyApp.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // Define o título do aplicativo.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planetas',
      theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 118, 47, 240)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(
        title: 'Planetas',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

 // Representa a tela inicial do app, exibindo a lista de planetas.
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta();

   // Lista para armazenar os planetas que serão exibidos na tela.
  List<Planeta> _planetas = [];

    // Inicializa o estado chamando o método para carregar os planetas.
  @override
  void initState() {
    super.initState();
    _AtualizarPlanetas();
  }

  Future<void> _AtualizarPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = resultado;
    });
  }

 // Navega para a tela de inclusão de um novo planeta e atualiza a lista ao finalizar.
  void _incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: true,
          planeta: Planeta.vazio(),
          onFinalizado: () {
            _AtualizarPlanetas();
          },
        ),
      ),
    );
  }

// Navega para a tela de edição de um planeta existente e atualiza a lista ao finalizar.
  void _alterarPlaneta(BuildContext context, planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: false,
          planeta: planeta,
          onFinalizado: () {
            _AtualizarPlanetas();
          },
        ),
      ),
    );
  }

  // Exclui um planeta pelo ID usando o controlador e atualiza a lista.
  void _excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    _AtualizarPlanetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

    // Corpo da tela, exibindo uma lista de planetas com opções para editar e excluir.
        body: ListView.builder(
        itemCount: _planetas.length,
        itemBuilder: (context, index) {
          final planeta = _planetas[index];
          return ListTile(
              title: Text(planeta.nome),
              subtitle: Text(planeta.apelido!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _alterarPlaneta(context, planeta),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _excluirPlaneta(planeta.id!),
                  ),
                ],
              ));
        },
      ),

      // Botão de ação flutuante para incluir um novo planeta.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incluirPlaneta(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
