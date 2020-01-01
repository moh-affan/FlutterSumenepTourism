const Map<String, String> tableDefinitions = {
  tabelOrders:
      "CREATE TABLE IF NOT EXISTS $tabelOrders (orderId INTEGER PRIMARY KEY, meja TEXT, orderMakanan TEXT, orderMinuman TEXT, tanggal TEXT, hargaTotal REAL, sync NUMERIC)",
  tabelTemp:
      "CREATE TABLE IF NOT EXISTS $tabelTemp (id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT UNIQUE, response TEXT, lastUpdate TEXT)",
};

const String tabelOrders = "orders";
const String tabelTemp = "temp";
