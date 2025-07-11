import 'package:click_happysoft_app/db_sql/db_helper.dart';
import 'package:click_happysoft_app/orders_page/classes/orders_class.dart';

class OrderSqlManager {
  Future<int> insertOrder(Order order) async {
    final db = await DBHelper().database;
    return await db.insert('orders', order.toMap());
  }

  Future<List<Order>> getOrders() async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('orders');

    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

  Future<int> updateOrder(Order order) async {
    final db = await DBHelper().database;
    return await db.update(
      'orders',
      order.toMap(),
      where: 'orderId = ?',
      whereArgs: [order.orderId],
    );
  }

  Future<int> deleteOrder(int orderId) async {
    final db = await DBHelper().database;
    return await db.delete(
      'orders',
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }

  Future<List<Order>> searchOrders(String keyword) async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'productName LIKE ? OR customerName LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
    );

    return List.generate(maps.length, (i) => Order.fromMap(maps[i]));
  }
}
