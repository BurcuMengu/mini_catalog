import 'package:flutter/material.dart';

void main() {
  runApp(const MiniCatalogApp());
}

class MiniCatalogApp extends StatelessWidget {
  const MiniCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Catalog',
      scrollBehavior: const NoStretchScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ProductListPage(),
    );
  }
}

class NoStretchScrollBehavior extends MaterialScrollBehavior {
  const NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.specifications,
    required this.price,
    required this.imagePath,
  });

  final int id;
  final String name;
  final String category;
  final String description;
  final List<String> specifications;
  final double price;
  final String imagePath;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      specifications: List<String>.from(json['specifications'] as List),
      price: (json['price'] as num).toDouble(),
      imagePath: json['imagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'specifications': specifications,
      'price': price,
      'imagePath': imagePath,
    };
  }
}

const List<Map<String, dynamic>> _productJson = [
  {
    'id': 1,
    'name': 'Wireless Mouse',
    'category': 'Electronics',
    'description':
        'An ergonomic wireless mouse designed for daily work and study. It offers silent clicks, stable connection, smooth tracking, and long battery life so you can use it comfortably for long hours.',
    'specifications': [
      'Connection: 2.4 GHz Wireless',
      'Buttons: 4 Silent Buttons',
      'Sensor: Optical 1600 DPI',
      'Battery: Up to 12 months',
      'Weight: 78 g',
    ],
    'price': 349.90,
    'imagePath': 'assets/images/mouse.png',
  },
  {
    'id': 2,
    'name': 'Bluetooth Headphones',
    'category': 'Electronics',
    'description':
        'Bluetooth headphones with clear audio, balanced bass, and a comfortable over-ear design. Ideal for music, online classes, and calls, with a battery that lasts through the day.',
    'specifications': [
      'Bluetooth: Version 5.3',
      'Playback Time: Up to 30 hours',
      'Charging Port: USB-C',
      'Microphone: Built-in mic for calls',
      'Weight: 210 g',
    ],
    'price': 799.00,
    'imagePath': 'assets/images/headphone.png',
  },
  {
    'id': 3,
    'name': 'Thermos',
    'category': 'Home',
    'description':
        'A durable stainless-steel thermos that keeps beverages hot for up to 8 hours or cold for up to 12 hours. Leak-resistant cap makes it practical for office, school, and travel.',
    'specifications': [
      'Material: Stainless Steel',
      'Capacity: 500 ml',
      'Heat Retention: Up to 8 hours',
      'Cold Retention: Up to 12 hours',
      'Feature: Leak-resistant lid',
    ],
    'price': 229.50,
    'imagePath': 'assets/images/thermos.png',
  },
  {
    'id': 4,
    'name': 'Backpack',
    'category': 'Accessories',
    'description':
        'A lightweight multi-pocket backpack suitable for school, commuting, and everyday use. Includes a roomy main compartment, front quick-access pocket, and padded shoulder straps.',
    'specifications': [
      'Material: Water-resistant fabric',
      'Capacity: 22 L',
      'Compartments: 5 pockets',
      'Fits: Up to 15.6-inch laptop',
      'Weight: 520 g',
    ],
    'price': 459.99,
    'imagePath': 'assets/images/bag.png',
  },
  {
    'id': 5,
    'name': 'Notebook Set',
    'category': 'Stationery',
    'description':
        'A practical 3-pack lined notebook set for class notes, planning, and journaling. Smooth paper supports both pencil and pen, while the durable cover protects pages in your bag.',
    'specifications': [
      'Pack: 3 notebooks',
      'Page Count: 80 pages each',
      'Paper Type: Lined',
      'Size: A5',
      'Cover: Flexible durable cover',
    ],
    'price': 119.90,
    'imagePath': 'assets/images/notebook.png',
  },
  {
    'id': 6,
    'name': 'Desk Lamp',
    'category': 'Home',
    'description':
        'A modern desk lamp with adjustable brightness levels for reading, studying, and late-night work. Its flexible neck helps direct light exactly where you need it while reducing eye strain.',
    'specifications': [
      'Brightness: 3 levels',
      'Power: 8W LED',
      'Color Temperature: 3000K-6000K',
      'Neck: Flexible 180-degree design',
      'Power Source: USB adapter',
    ],
    'price': 389.75,
    'imagePath': 'assets/images/lamp.png',
  },
];

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final List<Product> _allProducts =
      _productJson.map(Product.fromJson).toList(growable: false);
  final Map<int, int> _cartQuantities = {};

  String _query = '';
  String _selectedCategory = 'All Categories';

  int get _cartCount {
    return _cartQuantities.values.fold<int>(0, (sum, qty) => sum + qty);
  }

  List<String> get _categories {
    final categorySet = <String>{'All Categories'};
    for (final product in _allProducts) {
      categorySet.add(product.category);
    }
    return categorySet.toList();
  }

  List<Product> get _filteredProducts {
    return _allProducts.where((product) {
      final matchesCategory = _selectedCategory == 'All Categories' ||
          product.category == _selectedCategory;
      final matchesQuery =
          product.name.toLowerCase().contains(_query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _openProductDetail(Product product) async {
    final addedProduct = await Navigator.push<Product>(
      context,
      MaterialPageRoute<Product>(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );

    if (addedProduct != null && mounted) {
      setState(() {
        _cartQuantities.update(
          addedProduct.id,
          (currentQty) => currentQty + 1,
          ifAbsent: () => 1,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${addedProduct.name} added to cart.')),
      );
    }
  }

  void _openCartPage() {
    Navigator.push<Map<int, int>>(
      context,
      MaterialPageRoute<Map<int, int>>(
        builder: (context) => CartPage(
          allProducts: _allProducts,
          initialQuantities: _cartQuantities,
        ),
      ),
    ).then((updatedQuantities) {
      if (updatedQuantities == null || !mounted) return;
      setState(() {
        _cartQuantities
          ..clear()
          ..addAll(updatedQuantities);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Catalog'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: _openCartPage,
              child: Center(
                child: Chip(
                  avatar: const Icon(Icons.shopping_cart, size: 18),
                  label: Text('$_cartCount'),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search product...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value.trim();
                });
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Category: '),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: _categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('No products found for this filter.'))
                  : GridView.builder(
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.74,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          onTap: () => _openProductDetail(product),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  product.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.image_not_supported_outlined, size: 40),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    product.category,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onTap,
                      child: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 220,
              child: Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  product.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.image_not_supported_outlined, size: 56),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Category: ${product.category}'),
            const SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(product.description),
            const SizedBox(height: 16),
            Text(
              'Specifications',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...product.specifications.map(
              (spec) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('- $spec'),
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context, product);
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
    required this.allProducts,
    required this.initialQuantities,
  });

  final List<Product> allProducts;
  final Map<int, int> initialQuantities;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final Map<int, int> _cartQuantities;

  @override
  void initState() {
    super.initState();
    _cartQuantities = Map<int, int>.from(widget.initialQuantities);
  }

  List<Product> get _cartProducts {
    return widget.allProducts
        .where((product) => (_cartQuantities[product.id] ?? 0) > 0)
        .toList(growable: false);
  }

  double get _totalPrice {
    return _cartProducts.fold<double>(0, (sum, product) {
      final qty = _cartQuantities[product.id] ?? 0;
      return sum + (product.price * qty);
    });
  }

  void _increase(Product product) {
    setState(() {
      _cartQuantities.update(
        product.id,
        (currentQty) => currentQty + 1,
        ifAbsent: () => 1,
      );
    });
  }

  void _decrease(Product product) {
    setState(() {
      final current = _cartQuantities[product.id] ?? 0;
      if (current <= 1) {
        _cartQuantities.remove(product.id);
      } else {
        _cartQuantities[product.id] = current - 1;
      }
    });
  }

  void _remove(Product product) {
    setState(() {
      _cartQuantities.remove(product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProducts = _cartProducts;
    final totalPrice = _totalPrice;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _cartQuantities);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _cartQuantities);
            },
          ),
        ),
        body: cartProducts.isEmpty
            ? const Center(child: Text('Your cart is empty.'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: cartProducts.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = cartProducts[index];
                        final qty = _cartQuantities[item.id] ?? 0;
                        return ListTile(
                          leading: SizedBox(
                            width: 40,
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported);
                              },
                            ),
                          ),
                          title: Text(item.name),
                        subtitle: Text(
                          '${item.category}  •  \$${item.price.toStringAsFixed(2)}',
                        ),
                          trailing: SizedBox(
                            width: 164,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  tooltip: 'Decrease',
                                  onPressed: () => _decrease(item),
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text('$qty'),
                                IconButton(
                                  tooltip: 'Increase',
                                  onPressed: () => _increase(item),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                                IconButton(
                                  tooltip: 'Remove',
                                  onPressed: () => _remove(item),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '\$${totalPrice.toStringAsFixed(2)}',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context, _cartQuantities);
                          },
                          child: const Text('Save Cart'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
