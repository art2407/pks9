import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final cartItems = cartProvider.items;
          
          if (cartItems.isEmpty) {
            return const Center(
              child: Text('Корзина пуста'),
            );
          }

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (ctx, i) {
              final item = cartItems.values.toList()[i];
              return Card(
                margin: const EdgeInsets.all(10),
                child: Dismissible(
                  key: Key(item.product.id.toString()),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Подтверждение'),
                          content: const Text('Вы уверены, что хотите удалить этот товар из корзины?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Отмена'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Удалить'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    cartProvider.removeItem(item.product.id);
                  },
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      item.product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item.product.title),
                    subtitle: Text('Цена: ${item.product.price * item.quantity} ₽'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                                                IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () async {
                            if (item.quantity == 1) {
                              final shouldRemove = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Предупреждение'),
                                    content: const Text('Товар будет удален из корзины. Продолжить?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('Отмена'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('Удалить'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (shouldRemove) {
                                cartProvider.decrementQuantity(item.product.id);
                              }
                            } else {
                              cartProvider.decrementQuantity(item.product.id);
                            }
                          },
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            cartProvider.incrementQuantity(item.product.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Итого: ${cartProvider.totalAmount} ₽',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}