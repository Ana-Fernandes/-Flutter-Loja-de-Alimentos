import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // Chaves globais para as seções
  final GlobalKey _sorvetesKey = GlobalKey();
  final GlobalKey _salgadosKey = GlobalKey();
  final GlobalKey _pizzasKey = GlobalKey();
  final GlobalKey _docesKey = GlobalKey(); // Adicionado a chave para doces

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);  // Ajuste para 4 abas

    // Listener para rolar até a seção correspondente quando o tab é clicado
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToSection(_tabController.index);
        });
      }
    });
  }

  // Função para rolar até a seção desejada
  void _scrollToSection(int index) {
    GlobalKey key;
    switch (index) {
      case 0:
        key = _sorvetesKey;
        break;
      case 1:
        key = _pizzasKey;
        break;
      case 2:
        key = _docesKey;
        break;
      case 3:
        key = _salgadosKey;
        break;
      default:
        return;
    }

    final context = key.currentContext;
    if (context != null) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final position = _scrollController.position;
      final sectionOffset = renderBox.localToGlobal(Offset.zero).dy;
      final appBarHeight = AppBar().preferredSize.height + MediaQuery.of(context).padding.top; // Altura do AppBar

      _scrollController.animateTo(
        sectionOffset - appBarHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Função para rolar para a seção clicada pelo IconButton
  void _scrollToSectionByKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final sectionOffset = renderBox.localToGlobal(Offset.zero).dy;
      final appBarHeight = AppBar().preferredSize.height + MediaQuery.of(context).padding.top;

      _scrollController.animateTo(
        sectionOffset - appBarHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(product.imagePath),
              const SizedBox(height: 16),
              Text(
                product.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                product.price,
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Adicione a lógica de compra aqui
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green, // Cor do texto branco
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Borda arredondada com raio de 8
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Padding interno
                ),
                child: const Text('COMPRAR AGORA'),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            // Banner
            Container(
              height: 100, // Altura do banner
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/ads.jpg'), // Caminho da imagem do banner
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // TabBar
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.icecream), text: "Sorvetes"),
                Tab(icon: Icon(Icons.local_pizza), text: "Pizzas"),
                Tab(icon: Icon(Icons.cake), text: "Doces"),
                Tab(icon: Icon(Icons.fastfood), text: "Salgados"),
              ],
            ),
          ],
        ),
        toolbarHeight: 160, // Ajuste a altura do AppBar para acomodar o banner e TabBar
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          SectionWidget(
            key: _sorvetesKey,
            title: "Sorvetes",
            products: [
              Product(imagePath: "assets/images/7.jpg", title: "Sorvete 1", price: "R\$ 10,00"),
              Product(imagePath: "assets/images/6.jpg", title: "Morango", price: "R\$ 12,00"),
              Product(imagePath: "assets/images/3.jpg", title: "Sorvete 3", price: "R\$ 15,00"),
              Product(imagePath: "assets/images/1.jpg", title: "Sorvete 4", price: "R\$ 18,00"),
              Product(imagePath: "assets/images/7.jpg", title: "Sorvete 1", price: "R\$ 10,00"),
              Product(imagePath: "assets/images/6.jpg", title: "Sorvete 2", price: "R\$ 12,00"),
              Product(imagePath: "assets/images/3.jpg", title: "Sorvete 3", price: "R\$ 15,00"),
              Product(imagePath: "assets/images/1.jpg", title: "Sorvete 4", price: "R\$ 18,00"),
            ],
            onProductTap: _showProductDetails,
          ),
          SectionWidget(
            key: _pizzasKey,
            title: "Pizzas",
            products: [
              Product(imagePath: "assets/images/8.jpg", title: "Pizza 1", price: "R\$ 30,00"),
              Product(imagePath: "assets/images/14.jpg", title: "Pizza 2", price: "R\$ 35,00"),
              Product(imagePath: "assets/images/17.jpg", title: "Pizza 3", price: "R\$ 40,00"),
              Product(imagePath: "assets/images/9.jpg", title: "Pizza 4", price: "R\$ 50,00"),
            ],
            onProductTap: _showProductDetails,
          ),
          SectionWidget(
            key: _docesKey,
            title: "Doces",
            products: [
              Product(imagePath: "assets/images/44.jpg", title: "Doce 1", price: "R\$ 8,00"),
              Product(imagePath: "assets/images/2312.jpg", title: "Doce 2", price: "R\$ 9,00"),
              Product(imagePath: "assets/images/33.jpg", title: "Doce 3", price: "R\$ 7,00"),
              Product(imagePath: "assets/images/6.jpg", title: "Doce 4", price: "R\$ 6,50"),
            ],
            onProductTap: _showProductDetails,
          ),
          SectionWidget(
            key: _salgadosKey,
            title: "Salgados",
            products: [
              Product(imagePath: "assets/images/23.jpg", title: "Salgado 1", price: "R\$ 8,00"),
              Product(imagePath: "assets/images/24.jpg", title: "Salgado 2", price: "R\$ 9,00"),
              Product(imagePath: "assets/images/22.jpg", title: "Salgado 3", price: "R\$ 7,00"),
              Product(imagePath: "assets/images/14.jpg", title: "Salgado 4", price: "R\$ 6,50"),
            ],
            onProductTap: _showProductDetails,
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _scrollToSectionByKey(_sorvetesKey),
            child: Icon(Icons.local_drink_rounded),
            heroTag: 'sucos',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _scrollToSectionByKey(_docesKey),
            child: Icon(Icons.coffee),
            heroTag: 'Café',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _scrollToSectionByKey(_pizzasKey),
            child: Icon(Icons.local_drink_outlined),
            heroTag: 'Refri',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _scrollToSectionByKey(_salgadosKey),
            child: Icon(Icons.no_drinks_sharp),
            heroTag: 'Drink',
          ),
        ],
      ),
    );
  }
}

class SectionWidget extends StatelessWidget {
  final String title;
  final List<Product> products;
  final void Function(Product) onProductTap;

  const SectionWidget({
    super.key,
    required this.title,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200, // Ajuste a altura conforme necessário
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () => onProductTap(product),
                  child: Card(
                    elevation: 4.0,
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            product.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                product.price,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String imagePath;
  final String title;
  final String price;

  Product({required this.imagePath, required this.title, required this.price});
}
